class PhotosController < ApplicationController
  action :index, :destroy, :create_json => :add

  def list
    @photos = Photo.all
    render :partial => 'list'
  end
end
