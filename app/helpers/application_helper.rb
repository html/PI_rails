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

  def require_jquery_modal
    require_jquery

    once :require_jquery_modal do
      content_for :head do
        javascript_include_tag('jquery/jqModal') + stylesheet_link_tag('jqModal')
      end
    end
  end

  def require_jquery_fancybox
    require_jquery
    render :partial => '/fancybox'
    nil
  end

  def global_url_for(str)
    @host + str
  end

  def link_to_void(title, *args)
    link_to title, 'javascript:;', *args
  end

  def new_mark
    '<img src="/images/new.png" class="fl" style="margin:3px 0 0 5px"/>'
  end

  def is_admin
    @current_user && @current_user.group_id == 5
  end

  def forum_url
    sprintf("http://forum.%s/", APPLICATION_HOST)
  end

  def poll_view_result_url(forum_id, topic_id)
    sprintf("http://forum.%s/viewtopic.php?f=%s&t=%s&start=0&view=viewpoll", APPLICATION_HOST, forum_id, topic_id)
  end
end
