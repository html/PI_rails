class AdsController < ApplicationController
  include AdsHelper
  before_filter :transform_params, :only => :create
  action :index, :show, :new, :create, :edit, :update, :destroy

  def transform_params
    if params[:ad] && params[:tag_list]
      params[:ad][:tag_list] = params[:tag_list]
    end

    if @current_user && params[:ad]
      params[:ad][:user_id] = @current_user
    end
  end

  def by_tag
    @tag = params[:tag]
    not_found if !tags.include?(@tag.to_sym)
    @ads = Ad.by_tag(@tag)
  end

  def all
    @ads = Ad.latest
    render :by_tag
  end

  def search
    if params[:q]
      @values = params[:q].to_s.split /\s+/

      if @values && !@values.empty?
        @ads = Ad.title_or_content_like_any(@values)
      end
    end

    if !defined?(@ads)
      @ads = []
    end
  end

  def sitemap
    @items = Ad.all

    render :layout => 'sitemap'
  end
end
