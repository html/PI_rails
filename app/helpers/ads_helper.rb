module AdsHelper
  B = { :controller => :ads }
  def ads_path
    url_for(B)
  end

  def new_ad_path
    url_for(B.merge(:action => :new))
  end

  def create_ad_path
    url_for(B.merge(:action => :create))
  end

  def ad_path(ad)
    url_for(B.merge(:action => :show, :id => ad.to_param))
  end

  def edit_ad_path(ad)
    url_for(B.merge(:action => :edit, :id => ad.to_param))
  end

  def destroy_ad_path(ad)
    url_for(B.merge(:action => :destroy, :id => ad.to_param))
  end

  def link_to_image(img, image_opts = {}, link_opts = {})
    image_opts[:hover_image] = '/images/hover_ads/' + img.to_s + '.png'
    image_opts[:class] = 'swap'
    link_to image_tag('/images/ads/' + img.to_s + '.png', image_opts), url_for( :controller => :ads, :action => 'by_tag', :tag => img ), link_opts
  end

  def tags
    [ :buy, :sell, :found, :hire, :lost, :work, :stuff, :others]
  end

  def tags_options
    tags.inject({ '< виберіть розділ >' => ''}){ |a, val| a[t(val)] = val.to_s;a}.sort
  end

  def search_path
    url_for(B.merge(:action => :search))
  end
end
