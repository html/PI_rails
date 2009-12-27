class MapController < ApplicationController

  def flash
    render :text => File.open(RAILS_ROOT + '/public/images/jquery.clipboard.swf').read, :content_type => "application/x-shockwave-flash"
  end
end
