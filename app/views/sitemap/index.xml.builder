
xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
    Page.live.each do |page|
      xml.url do
        xml.loc "https://#{Rails.application.config.host_name}#{full_page_path(page)}"
        xml.lastmod page.updated_at.iso8601
      end
    end
end
