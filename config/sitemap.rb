SitemapGenerator::Sitemap.default_host = "https://pankabi.com"
SitemapGenerator::Sitemap.compress = false

SitemapGenerator::Sitemap.create do
  add root_path
  add breads_path

  # パン詳細ページ
  Bread.find_each do |bread|
    add bread_path(bread), lastmod: bread.updated_at
  end

end