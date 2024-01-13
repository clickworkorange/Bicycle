module PagesHelper

	def inline_images(page) 
		# TODO: handle case of too few images
		page.body % page.images.inline.map { |image| image_to_md(page, image) }
	end

	def image_to_md(page, image)
		"[![" + image.alt_text + "](" + url_for(image.image_file.variant(resize_to_limit: [480, nil])) + ")](" + page_image_path(page, image) + ")"
	end
end
