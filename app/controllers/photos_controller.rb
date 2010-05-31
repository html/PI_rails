class PhotosController < ApplicationController
  before_filter :assign_show_map, :only => [:index, :my]
  action :create_json => :add

  access_control do |ab,cd|
    allow :admin
    debugger;true
    allow all, :to => [:index, :save_point, :coord, :list]
    allow logged_in, :to => [:my, :add]
    #XXX
    allow logged_in, :of => :photo, :to => [:destroy]
  end

  before_filter :set_owner_id, :only => [:add]

  def list
    @photos = Photo.all
    render :partial => 'list'
  end

  def index
    @photos = Photo.paginate_with_points(params[:page])
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

  def my
    @title = "Фотогалерея - мої фотографії"
    @photos = @current_user.photos(params[:page])
    @display_delete_link = true
    render :index
  end

  def destroy
    @photo = Photo.find(params[:id])
    not_found unless @photo

    flash[:notice] = 'Photo was successfully destroyed'
    @photo.update_attributes :public => false

    redirect_to '/my'
  end

  protected
    def not_found_json
      render :text => nil.to_json
    end

    def assign_show_map
      @show_map = cookies[:include_map].nil? ?  1 : cookies[:include_map].to_i
    end

    def set_owner_id
      params[:photo][:owner_id] = current_user.id
    end
end
