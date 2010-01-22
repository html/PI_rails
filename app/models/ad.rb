class Ad < ActiveRecord::Base
  include PageInfoAfterInitialize
  has_one :page_info, :as => :item
  extend LastModified
  acts_as_taggable
  validates_presence_of :title, :content, :tag_list, :contacts

  def self.latest(options = {})
    all({:order => 'created_at DESC'}.merge(options))
  end

  def self.latest_few
    latest({ :limit => 5 })
  end
  def self.by_tag(tag)
    find_tagged_with(tag, :order => 'created_at DESC')
  end
end
