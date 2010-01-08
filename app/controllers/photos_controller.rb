class PhotosController < ApplicationController
  action :index, :destroy, :create_json => :add

  access_control do
    allow :admin
    allow all, :to => [:index]
  end

  def list
    @photos = Photo.all
    render :partial => 'list'
  end
end
