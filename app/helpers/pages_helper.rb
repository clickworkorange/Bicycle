module PagesHelper
	require "nokogiri"

	def full_page_path(page)
		path = []
		if page.url.present?
			path << page.url
		else
			path << "/"
			page.ancestors.each do |parent|
				path << parent.friendly_id
			end
			path << page.friendly_id
		end
		File.join(path)
	end

	def image_file_path(blob)
		url_for(blob)
    end

	def parse_body(page)
		# TODO: sanitize
		body = Kramdown::Document.new(
			inline_images(page, page.images.inline), 
			syntax_highlighter: "rouge", 
			syntax_highlighter_opts: {line_numbers: true, theme: "monokai"}
		).to_html.html_safe
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

	def first_banner_path(page, width=320, ratio=2.33)
		if page.images.banner.any?
			path = image_file_path(page.images.banner.first.image_file.variant(resize_to_fill: [width, width/ratio]))
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

	def thumbnail_image(image, size, aspect)
		# TODO: implement srcset (not really needed)
		# TODO: define image sizes somewhere...
		aspect = aspect || image_aspect(image)
		css_class = ""
		if aspect[1] > aspect[0] 
			# portrait
			css_class = "port"
			height = size
			width = (size*aspect[0])/aspect[1]
		else
			css_class = "lscp"
			height = (size*aspect[1])/aspect[0]
			width = size
		end
		image_tag(
			image_file_path(image.image_file.variant(resize_to_fill: [width, height])),
			alt: image.alt_text, 
			style: "aspect-ratio: #{aspect[0]}/#{aspect[1]};",
			class: css_class,
			loading: "lazy"
		)
	end

	def fullscreen_image(image, size=800)
		# TODO: investigate using <picture> instead of <img>
		aspect = image_aspect(image)
		factor = 1.5
		base = aspect[0] > aspect[1] ? [size, nil] : [nil, size]
		up   = aspect[0] > aspect[1] ? [size*factor, nil] : [nil, size*factor]
		down = aspect[0] > aspect[1] ? [size/factor, nil] : [nil, size/factor] 
		img = image_file_path(image.image_file.variant(resize_to_limit: base))
		image_tag(
			img,
			srcset: [[image_file_path(image.image_file.variant(resize_to_limit: up)), "1200w"], [img, "800w"], [image_file_path(image.image_file.variant(resize_to_limit: down)), "400w"]],
			alt: image.alt_text, 
			style: css_aspect(image),
			loading: "lazy"
		)
	end

	def inline_images(page, images) 
		images = page.images.inline
		page.body.gsub(/fig\[(\d+)\]/).each do |fig| 
			index = $1.to_i - 1
			unless images[index].nil?
				image_to_figure(page, images[index])
			end
		end
	end

	def image_to_figure(page, image)
		# TODO: width
		render partial: "figure", locals: {image: image, size: 240, aspect: nil}
	end

	# TODO: most of these are image helpers, not page helpers...
	# TODO: define a comprehensive set of tokens for image/gallery/banner insertion
	# TODO: get rid of unnecessary <div> tags around kramdown/rouge code blocks

	def svg_icon(icon)
		# TODO: add role="img" to <svg> and <title>[description]</title> inside it, translating the description
		# TODO: add aria-hidden="true" to <svg> of purely decorative icons (e.g. tree-lines)
		path = File.join(Rails.root, "app", "assets", "images", "icons", icon)
		sanitize(File.read(path + ".svg"), tags: %w(svg g path), attributes: %w(xmlns width height viewBox d))
	end
end
