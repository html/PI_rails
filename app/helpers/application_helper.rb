# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def javascript_include_jquery 
    once :load_jquery do
      javascript_include_tag 'jquery.min'
    end
  end

  def require_jquery
    once :load_jquery do
      content_for :head do
        javascript_include_tag 'jquery.min'
      end
    end
  end

  def global_url_for(str)
    @host + str
  end

  def require_tooltips
    require_jquery

    once :tooltips do
      content_for :head do
        render :partial => '/tooltip'
      end
    end
  end
  
  def link_to_void(title, *args)
    link_to title, 'javascript:;', *args
  end
end
