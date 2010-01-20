class IndexController < ApplicationController
  def index
    @ads = Ad.latest_few
    @articles = Article.latest_few
    @photo = Photo.random
  end
end
