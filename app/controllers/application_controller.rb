# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'create_json'
require 'phpbb_extension'
require 'comments/comment'
require 'I18n'
require 'map_coord_choice'
require 'bishop'

class ApplicationController < ActionController::Base
  include PhpbbAuth
  include ::Actions

  rescue_from 'Acl9::AccessDenied', :with => :access_denied
  rescue_from 'ActiveRecord::RecordNotFound', :with => :not_found
  rescue_from 'ActionController::RoutingError', :with => :not_found

  helper_method :current_user
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :assign_ads_from_cookies
  before_filter :assign_host
  before_filter :set_current_user
  before_filter :assign_poll
  before_filter do |controller|
    if controller.respond_to? :index
      controller.send(:has_one_page_info, :index)
    end
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
  def assign_host
    @host = 'http://' +  APPLICATION_HOST
  end

  def access_denied
    render :file => "#{RAILS_ROOT}/public/422.html", :status => 422 and return
  end

  def not_found
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404 and return
  end

  def set_current_user
    @current_user = current_user
  end
  
  def assign_poll
    if RAILS_ENV != 'test'
      @poll = PhpbbTopics.last_poll(cookies, @current_user)
    end
  end

  def assign_photo
    @photo = Photo.random
  end

  def self.has_one_page_info(*args)
    before_filter do |controller|
      controller.send(:has_one_page_info, *args)
    end
  end

  def has_one_page_info(*args)
    options = args.extract_options!
    args.each do |arg|
      name = [request.params[:controller], arg].join '-'
      item = PageInfo.record_for(name) || PageInfo.create_record_for(name)

      if arg.to_s == request.params[:action]
        set_page item
      end
    end
  end

  def has_page_info_and_uses_it(id)
    has_one_page_info id
    set_page_id [request.params[:controller], id.to_s].join '-'
  end

  def set_page_id(id)
    set_page PageInfo.find_by_page_id(id)
  end

  def set_page(page)
    page.increment!(:views)
    PageInfo::page = page
  end

  def assign_ads_from_cookies
    @cookied_ads = Ad.by_cookies(cookies)
  end

  before_filter :save_comment_if_there_is_one
  def save_comment_if_there_is_one
    if params[:comment]
      result = Comments::Manager::create_comment(params[:comment])

      if result === true
        flash[:notice] = "Коментар успішно додано"
        return redirect_to_back_or_default
      end

      if result
        flash[:notice] = "Виникли помилки під час збереження відгуку"
        @comment = result
      end
    end
  end

  before_filter :remove_comment_if_need_to
  def remove_comment_if_need_to
    if params[:remove_comment]
      comment = Comments::Comment.find(params[:remove_comment])
      comment.destroy
      redirect_to request.request_uri.gsub(/\?[^?]*$/, '')
    end
  end

  before_filter :update_comment_status_if_need_to
  def update_comment_status_if_need_to
    if params[:update_comment_status]
      comment = Comments::Comment.find(params[:update_comment_status])
      return not_found unless comment
      return not_found unless ['spam', 'not_spam'].include?(params[:status])

      @status = params[:status]

      classifier = Bishop::Bayes.new 

      def classifier.classify(string)
        results = guess(string).inject({}){|hash,b| (hash[b[0]] = b[1]);hash }
        results['spam'] ||= 0
        results['not_spam'] ||= 0

        if results['spam'] > results['not_spam']
          'spam'
        else
          'not_spam'
        end
      end

      comment.update_attributes :status => @status
      comments = Comments::Comment.find(:all)

      def train_classifier(comments, classifier)
        comments.each do |comment|
          if comment.status == 'spam'
            classifier.train('spam', comment.content)
          elsif comment.status.nil?
            classifier.train('not_spam', comment.content)
          end
        end
      end

      train_classifier(comments, classifier)

      def update_comments_statuses(comments, classifier)
        def comment_is_possibly_spam?(comment, classifier)
          classifier.classify(comment.content) == 'spam'
        end

        def comment_is_not_like_spam?(comment, classifier)
          comment.status != 'spam'
        end

        comments.each do |comment|
          if comment.status != 'spam' && comment.status != 'not_spam' 
            if comment_is_possibly_spam?(comment, classifier)
              comment.update_attributes :status => 'possibly_spam'
            else
              comment.update_attributes :status => ''
            end
          end
        end
      end

      update_comments_statuses(comments, classifier)
      
      redirect_to request.request_uri.gsub(/\?[^?]*$/, '')
    end
  end

  def redirect_to_back_or_default(url = nil)
    redirect_to :back
  rescue
    redirect_to (url || root_path)
  end

  if false
    if RAILS_ENV == 'development'
      def first_admin_user
        PhpbbUser.first :conditions => { :group_id => 5 }
      end

      def first_non_admin_user
        PhpbbUser.first :conditions => { :group_id => 1 }
      end

      def current_user
        cookies["#{PHPBB_AUTH_COOKIE_NAME}_sid"] = 'test'
        first_admin_user
      end
    end
  end
end
