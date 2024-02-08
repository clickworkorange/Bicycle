module PagesHelper
  require "nokogiri"
  require "net/http"
  require "json"

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
    Kramdown::Document.new(
      process_tokens(page),
      syntax_highlighter: "rouge",
      syntax_highlighter_opts: {line_numbers: true, theme: "monokai"}
    ).to_html.html_safe
  end

  def parse_comment(comment)
    # TODO: https://github.com/gettalong/kramdown/blob/master/lib/kramdown/parser/kramdown.rb#L75
    Kramdown::Document.new(strip_tags(comment)).to_html.html_safe
  end

  def banner_background_css(page, switch = 600)
    first_banner = page.images.banner.first
    if first_banner
      large = first_banner.image_file.large_banner.url
      medium = first_banner.image_file.medium_banner.url
    else
      # fall back to default banners
      large = asset_path("#{page.template}_banner.jpg")
      medium = asset_path("#{page.template}_banner_medium.jpg")
    end
    style = "article > header { background-image: url(\"#{large}\"); }"
    style += "@media (max-width: #{switch}px) { article > header {"
    style += "background-image: url(\"#{medium}\");"
    style += "}}"
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

  def thumbnail_image(image, version = "thumb")
    if version == "square"
      url = image.image_file.square.url
      aspect = "1/1"
    else
      url = image.image_file.thumb.url
      aspect = image.aspect
    end
    image_tag(url, alt: image.alt_text, style: "aspect-ratio: #{aspect}", loading: "lazy")
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

  def process_tokens(page)
    page.body = inline_images(page)
    page.body = inline_galleries(page)
    page.body = inline_repos(page)
    page.body
  end

  def inline_repos(page)
    base_url = "https://api.github.com/repos"
    page.body.gsub(%r{repo\[(([a-zA-Z0-9/\-])+)\]}).each do
      uri = URI("#{base_url}#{$1}")
      result = Rails.cache.fetch($1, expires_in: 24.hours) do
        response = Net::HTTP.get(uri)
        repo = JSON.parse(response)
        break if repo["message"] # something went wrong
        render(partial: "github_repo", locals: {repo: repo})
      end
    end
  end

  def inline_images(page)
    inline = page.images.inline
    page.body.gsub(/fig\[(\d+)\]/).each do
      image = inline[$1.to_i - 1]
      if image.height > image.width
        css_class = "port"
      elsif image.height == image.width
        css_class = "square"
      else
        css_class = "lscp"
      end
      render(partial: "figure", locals: {image: image, version: "thumb", css_class: css_class}) if image
    end
  end

  def inline_galleries(page)
    page.body.gsub("[gallery]").each do
      gallery = page.images.gallery
      render(partial: "gallery", locals: {page: page, gallery: gallery}) if gallery
    end
  end

  # TODO: most of these are image helpers, not page helpers...
  # TODO: define a comprehensive set of tokens for image/gallery/banner insertion
  # TODO: get rid of unnecessary <div> tags around kramdown/rouge code blocks

  def svg_icon(icon)
    # TODO: add role="img" to <svg> and <title>[description]</title> inside it, translating the description
    # TODO: add aria-hidden="true" to <svg> of purely decorative icons (e.g. tree-lines)
    path = File.join(Rails.root, "app", "assets", "images", "icons", icon)
    sanitize(File.read("#{path}.svg"), tags: %w[svg g path], attributes: %w[xmlns width height viewBox d])
  end
end
