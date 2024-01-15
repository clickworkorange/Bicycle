module PagesHelper

	def inline_images(page) 
		# TODO: handle case of too few images
		page.body % page.images.inline.map { |image| image_to_md(page, image, 480) }
	end
	
	#TODO: def gallery_images(), def banner_images()

	def image_to_md(page, image, width)
		alt = image.alt_text
		img = url_for(image.image_file.variant(resize_to_limit: [width, nil]))
		url = page_image_path(page, image)
		"[![#{alt}](#{img})](#{url})"
	end

	def svg_icon(icon)
		path = File.join(Rails.root, "app", "assets", "images", "icons", icon)
		sanitize(File.read(path + ".svg"), tags: %w(svg g path), attributes: %w(xmlns width height viewBox d))
	end
end
