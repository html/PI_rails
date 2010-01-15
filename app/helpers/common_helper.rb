module CommonHelper
  def sitemap_xmlns(type = :sitemap)
    "http://www.sitemaps.org/schemas/sitemap/0.9/#{type.to_s}.xsd"
  end
end
