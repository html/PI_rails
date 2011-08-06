class ArticlesController < ApplicationController
  before_filter :assign_photo, :only => [:index]
  action :index, :show, :new, :create, :edit, :update
  
  access_control do
    allow :admin
    allow all, :to => [:show, :index, :css, :sitemap]
  end

  def css
    render :layout => false, :content_type => :css
  end

  def sitemap
    @items = Article.all

    render :layout => 'sitemap'
  end

  def destroy
    str = self.class.to_s.sub /Controller$/, ''
    var =  "@#{str.underscore.singularize}"
    model = str.singularize.camelize.constantize

    item = model.find(params[:id])
    flash[:notice] = str.singularize + ' was successfully destroyed'
    item.destroy

    respond_to do |format|
      format.html { redirect_to(eval("#{str.underscore.pluralize}_url")) }
      format.xml  { head :ok }
    end
  end
end
