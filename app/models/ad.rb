class Ad < ActiveRecord::Base
  acts_as_taggable
  validates_presence_of :title, :content, :tag_list, :contacts
end
