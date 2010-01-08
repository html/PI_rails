class PhpbbPollVote < ActiveRecord::Base
  establish_connection "phpbb_database_#{RAILS_ENV}"
end
