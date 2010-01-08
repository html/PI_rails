class PhpbbPollOption < ActiveRecord::Base
  establish_connection "phpbb_database_#{RAILS_ENV}"
  has_many :phpbb_poll_votes, :foreign_key => 'poll_option_id', :primary_key => 'poll_option_id'
end
