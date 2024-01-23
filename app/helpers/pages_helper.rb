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

	def parse_body(page)
		# TODO: sanitize
		body = Kramdown::Document.new(
			inline_images(page, page.images.inline), 
			syntax_highlighter: "rouge", 
			syntax_highlighter_opts: {line_numbers: true, theme: "monokai"}
		).to_html.html_safe
	end

	def banner_background_css(page)
		switch = 900
		style = ""
		if page.images.banner.any?
			large = page.images.banner.first.image_file.large_banner.url
			medium = page.images.banner.first.image_file.medium_banner.url
		else
			# fall back to default banners
			large = asset_path("#{page.template}_banner.jpg")
			medium = asset_path("#{page.template}_banner_medium.jpg")
		end
		content_tag(:style) do
			style += "article > header {"
			style += "background-image: url(\"#{large}\");"
			style += "} @media (max-width: #{switch}px) { article > header {"
			style += "background-image: url(\"#{medium}\");"
			style += "}}"
		end
		style.html_safe
	end

	def banner_thumb(page)
		aspect = "2.33/1"
		if page.images.banner.any?
			url = page.images.banner.first.image_file.small_banner.url
		else
			# fall back to default banners
			url = asset_path("#{page.template}_banner_small.jpg")
		end
		image_tag(
			url,
			# alt: image.alt_text, # hmmm
			style: "aspect-ratio: #{aspect}",
			loading: "lazy"
		)
	end

	def thumbnail_image(image, version="thumb")
		if version == "square"
			url = image.image_file.square.url
			aspect = "1/1"
			css_class = "square"
		else
			url = image.image_file.thumb.url
			aspect = image.aspect
			if image.height > image.width
				css_class = "port"
			else
				css_class = "lscp"
			end
		end
		image_tag(
			url,
			alt: image.alt_text, 
			style: "aspect-ratio: #{aspect}",
			class: css_class,
			loading: "lazy"
		)
	end

	def fullscreen_image(image)
		image_tag(
			image.image_file.medium.url,
			srcset: [
				[image.image_file.large.url, "1200w"], 
				[image.image_file.medium.url, "800w"], 
				[image.image_file.small.url, "600w"]
			],
			alt: image.alt_text, 
			style: "aspect-ratio: #{image.aspect};",
			loading: "lazy"
		)
	end

	def inline_images(page, images) 
		images = page.images.inline
		page.body.gsub(/fig\[(\d+)\]/).each do |fig| 
			index = $1.to_i - 1
			unless images[index].nil?
				image_to_figure(page, images[index], "thumb")
			end
		end
	end

	def image_to_figure(page, image, version)
		render partial: "figure", locals: {image: image, version: version}
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
