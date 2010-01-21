class LinksController < ApplicationController
  before_filter :assign_photo, :only => [:index]
  action :index, :create_json => :add
end
