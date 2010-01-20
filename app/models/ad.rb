class Ad < ActiveRecord::Base
  acts_as_taggable
  validates_presence_of :title, :content, :tag_list, :contacts

  def self.latest(options = {})
    all({:order => 'created_at DESC'}.merge(options))
  end

  def self.latest_few
    latest({ :limit => 5 })
  end
end
