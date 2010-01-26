class Article < ActiveRecord::Base
  include PageInfoAfterInitialize
  has_one :page_info, :as => :item
  extend LastModified

  def self.latest_few
    all(:order => 'created_at DESC', :limit => 5)
  end

  def self.all
    find(:all, :order => 'created_at DESC')
  end
end
