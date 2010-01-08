class PhpbbTopics < ActiveRecord::Base
  establish_connection "phpbb_database_#{RAILS_ENV}"
  has_many :phpbb_poll_options, :foreign_key => 'topic_id', :primary_key => 'topic_id'

  def self.last_items
    
  end

  def self.last_poll(cookies, user = nil)
    find(:first, :order => 'poll_start DESC', :conditions => 'poll_start > 0 AND topic_id NOT IN(' + (cookies_to_forbidden_poll_ids(cookies) + forbidden_poll_ids(user)).join(',') + ')')
  end

  def self.cookies_to_forbidden_poll_ids(cookies)
    re = /#{PHPBB_AUTH_COOKIE_NAME}_poll_(\d)/
    r = []
    cookies.map do |key, val|
      matchdata = re.match(key)
      if matchdata
        r.push(matchdata[1])
      end
    end
    r
  end

  def self.forbidden_poll_ids(user)
    if(user)
      (PhpbbPollVote.find_by_vote_user_id(user.user_id, :select => 'topic_id') || []).map(&:topic_id)
    else
      []
    end
  end
end
