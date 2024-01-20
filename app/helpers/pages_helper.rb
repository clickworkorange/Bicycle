module PagesHelper

	def full_page_path(page)
		path = ["/"]
		page.ancestors.each do |parent|
			path << parent.friendly_id
		end
		path << page.friendly_id
		File.join(path)
	end

	def css_aspect(image)
		aspect = image_aspect(image)
		"aspect-ratio: #{aspect[0]}/#{aspect[1]};"
	end

	def image_aspect(image) 
		calc_fraction(image.image_file.metadata["width"],image.image_file.metadata["height"])
	end

	# TODO: "private"height
	def calc_fraction(numerator, denominator)
		result = [0,0]
		swap = false
		if numerator < denominator 
			# swap places
			numerator = numerator ^ denominator
			denominator = numerator ^ denominator
			numerator = numerator ^ denominator
			swap = true
		end
		if numerator < 2 || denominator < 2
			numerator *= 10
			denominator *= 10
		end
		result = [1,1] if numerator === denominator 
		gcd = numerator.gcd(denominator)
		if swap
			[denominator / gcd, numerator / gcd]
		else 
			[numerator / gcd, denominator / gcd];
		end
	end

	def thumbnail_image(image, size=240)
		# TODO: implement srcset (not really needed)
		image_tag(
			url_for(image.image_file.variant(resize_to_fill: [size, size])),
			alt: image.alt_text, 
			style: "aspect-ratio: 1/1;"
		)
	end

	def first_banner_path(page, width=320, ratio=2.33)
		if page.images.banner.any?
			path = url_for(page.images.banner.first.image_file.variant(resize_to_fill: [width, width/ratio]))
		else
			path = nil
		end
		path
	end

	def banner_background_css(page, widths=[1200,800], switch=900, ratio=2.33)
		style = ""
		large = first_banner_path(page, widths[0], ratio)
		small = first_banner_path(page, widths[1], ratio)
		unless large && small
			# fall back to default banners
			large = asset_path("#{page.template}_banner.jpg")
			small = asset_path("#{page.template}_banner_medium.jpg")
		end
		content_tag(:style) do
			style += "article > header {"
			style += "background-image: url(\"#{large}\");"
			style += "} @media (max-width: #{switch}px) { article > header {"
			style += "background-image: url(\"#{small}\");"
			style += "}}"
		end
		style.html_safe
	end

	def fullscreen_image(image, size=800)
		# TODO: investigate using <picture> instead of <img>
		aspect = image_aspect(image)
		factor = 1.5
		base = aspect[0] > aspect[1] ? [size, nil] : [nil, size]
		up   = aspect[0] > aspect[1] ? [size*factor, nil] : [nil, size*factor]
		down = aspect[0] > aspect[1] ? [size/factor, nil] : [nil, size/factor] 
		img = url_for(image.image_file.variant(resize_to_limit: base))
		image_tag(
			img,
			srcset: [[url_for(image.image_file.variant(resize_to_limit: up)), "1200w"], [img, "800w"], [url_for(image.image_file.variant(resize_to_limit: down)), "400w"]],
			alt: image.alt_text, 
			style: css_aspect(image)
		)
	end

	def inline_images(page, width=480) 
		# TODO: handle case of too few images
		page.body % page.images.inline.map { |image| image_to_md(page, image, width) }
	end

	# TODO: most of these are image helpers, not page helpers...
	# TODO: def gallery_images(), def banner_images()
	# TODO: define a comprehensive set of tokens for image/gallery/banner insertion
	# TODO: get rid of unnecessary <div> tags around kramdown/rouge code blocks

	def image_to_md(page, image, width)
		alt = image.alt_text
		img = url_for(image.image_file.variant(resize_to_limit: [width, nil]))
		url = page_image_path(page, image)
		"[![#{alt}](#{img})](#{url})"
	end

	def svg_icon(icon)
		# TODO: add role="img" to <svg> and <title>[description]</title> inside it, translating the description
		# TODO: add aria-hidden="true" to <svg> of purely decorative icons (e.g. tree-lines)
		path = File.join(Rails.root, "app", "assets", "images", "icons", icon)
		sanitize(File.read(path + ".svg"), tags: %w(svg g path), attributes: %w(xmlns width height viewBox d))
	end
end
