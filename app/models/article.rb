class Article < ActiveRecord::Base
  extend LastModified

  def self.latest_few
    all(:order => 'created_at DESC', :limit => 5)
  end
end
