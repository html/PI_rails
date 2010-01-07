class ArticlesController < ApplicationController
  action :index, :show, :new, :create, :edit, :update, :destroy

  def css
    render :layout => false, :content_type => :css
  end
end
