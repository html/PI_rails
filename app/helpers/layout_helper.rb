# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
require 'easter'

module LayoutHelper
  LOGOS = {
    [14,02] => 'valentine',
    [8, 03] => 'march8',
    [01,04] => 'april1'
  }

  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end
  
  def show_title?
    @show_title
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def file_contents(name)
    path = "#{RAILS_ROOT}/tmp/files/#{name}"
    
    if File.exists?(path) && File.readable?(path)
      File.open(path).read
    end
  end

  def logo_src
    today = Date.today
    index = [today.day, today.month]
    "/images/logo/%s.png" % (LOGOS[index] || (request.params[:controller] == 'weather' && [12,1,2].include?(today.month)  ? 'frosty' : (today_is_easter? ? 'easter' : 'main')))
  end

  def today_is_easter?
    easter(Date.today.year) == Date.today
  end
end
