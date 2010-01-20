class Article < ActiveRecord::Base
  def self.last_modified
    last.updated_at
  end

  def self.latest_few
    all(:order => 'created_at DESC', :limit => 5)
  end
end
