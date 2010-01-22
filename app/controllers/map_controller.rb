class MapController < ApplicationController
  def index
  end
  
  def sitemap
    render :layout => 'sitemap'
  end
end
