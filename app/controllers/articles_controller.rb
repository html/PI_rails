class ArticlesController < ApplicationController
  action :index, :show, :new, :create, :edit, :update, :destroy
  
  access_control do
    allow :admin
    allow all, :to => [:show, :index, :css, :sitemap]
  end

  def css
    render :layout => false, :content_type => :css
  end

  def sitemap
    @items = Article.all

    render :layout => 'sitemap'
  end
end
