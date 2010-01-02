class LinksController < ApplicationController
  action :index

  def add
    @link = Link.new(params[:link])
    if @link.save
      render :json => {:success => :true}
    else
      render :json => @link.errors
    end
  end
end
