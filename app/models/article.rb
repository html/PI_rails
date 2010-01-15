class Article < ActiveRecord::Base
  def self.last_modified
    last.updated_at
  end
end
