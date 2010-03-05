class PhotosController < ApplicationController
  action :destroy, :create_json => :add

  access_control do
    allow :admin
    allow all, :to => [:index, :save_point, :coord, :list]
  end

  def list
    @photos = Photo.all
    render :partial => 'list'
  end

  def index
    @photos = Photo.all_with_points
    @show_map = cookies[:include_map].nil? ?  1 : cookies[:include_map].to_i
  end

  def cords
    item = Photo.find(params[:id], :include => :point)
    render :json => item.cords
  end

  def save_point
    item = Photo.find(params[:item_id])

    return not_found unless item
    point = item.point || item.build_point

    render :json => point.save_with(params)
  end

  def coord
    item = Photo.find(params[:id])

    return not_found_json unless item
    point = item.point
    return not_found_json unless point

    render :text => [point.lat, point.lng].to_json
  end

  protected
    def not_found_json
      render :text => nil.to_json
    end
end
