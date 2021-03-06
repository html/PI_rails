class CommonController < ApplicationController
  access_control do
    allow :admin
    allow all, :to => [:sitemap, :menu]
  end

  def update_page_info
    @item = PageInfo.find(params[:id])
    @item.update_attributes(params[:page_info])

    if @item.save
      flash[:notice] = "Успішно збережено"
      redirect_to :back
    end
  end

  def sitemap
    render :layout => false
  end

  def menu
    render :partial => '/main_menu'
  end
end
