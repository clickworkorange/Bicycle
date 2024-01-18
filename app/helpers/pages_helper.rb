module PagesHelper

	def full_page_path(page)
		path = ["/"]
		page.ancestors.each do |parent|
			path << parent.friendly_id
		end
		path << page.friendly_id
		File.join(path)
	end

	def inline_images(page, width=480) 
		# TODO: handle case of too few images
		page.body % page.images.inline.map { |image| image_to_md(page, image, width) }
	end
	
	def first_banner_or_blank(page, width=400)
		# TODO: different blank banner depending on template
		# TODO: resize_to_fit (width*aspect)
		# TODO: set style="aspect-ratio: n/n;"
		# TODO: process also default banners (to get size & filesize down)
		if page.images.banner.any?
			path = url_for(page.images.banner.first.image_file.variant(resize_to_fill: [width, width/2.33]))
		else
			path = asset_path("#{page.template}_banner.jpg")
		end
		path
	end

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
