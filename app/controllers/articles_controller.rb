class ArticlesController < ApplicationController
  action :index, :show, :new, :create, :edit, :update, :destroy
  
  access_control do
    allow :admin
    allow all, :to => [:show, :index, :css]
  end

  def css
    render :layout => false, :content_type => :css
  end
end
