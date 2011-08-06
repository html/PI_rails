class Comments::Comment < ActiveRecord::Base
  validates_presence_of :content
end
