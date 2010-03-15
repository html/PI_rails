require 'digest'

class AdsController < ApplicationController
  has_one_page_info :all, :search
  include AdsHelper
  before_filter :transform_params, :only => :create
  action :create, :edit, :update

  def show
    @ad = Ad.find params[:id], :conditions => { :public => true }
    not_found unless @ad
    @owned_by_user = ad_is_owned_by_user(@ad)
  end

  def new
    @ad = Ad.new
    1.upto(3) { @ad.photos.build }
  end

  def transform_params
    if params[:ad] && params[:tag_list]
      params[:ad][:tag_list] = params[:tag_list]
    end

    if @current_user && params[:ad]
      params[:ad][:user_id] = @current_user.user_id
    else
      hash = Digest::MD5.hexdigest([Time.new.to_i, request.remote_ip, rand].join)
      cookies['ad_' + hash] = true
      params[:ad][:h] = hash
    end
  end

  def by_tag
    @tag = params[:tag]
    not_found if !tags.include?(@tag.to_sym)
    has_page_info_and_uses_it ['by_tag', @tag].join '-'
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

  def my
    if @current_user
      if @cookied_ads
        @cookied_ads.each do |item|
          cookies.delete('ad_' + item.h)
          item.user_id = @current_user.user_id
          item.save
        end
      end

      @ads = @current_user.ads
    else
      @ads = @cookied_ads
    end

    @title = 'Мої оголошення'
    render :by_tag
  end

  def destroy
    @item = Ad.find params[:id]

    if ad_is_owned_by_user(@item)
      @item.remove
    end

    flash[:notice] = 'Успішно видалено оголошення'
    redirect_to ads_url
  end

  def index
    redirect_to '/all'
  end

  protected
    def ad_is_owned_by_user(ad)
      (@current_user && @current_user.id = ad.user_id) || @cookied_ads.include?(ad)
    end
end
