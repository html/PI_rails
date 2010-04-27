class Ad < ActiveRecord::Base
  include PageInfoAfterInitialize
  has_one :page_info, :as => :item
  extend LastModified
  acts_as_taggable
  validates_presence_of :title, :content, :tag_list, :contacts
  has_and_belongs_to_many :photos

  before_create do |item|
    item.public = true
  end

  def self.latest(options = {})
    all({:order => 'created_at DESC', :conditions => { :public => true }}.merge(options))
  end

  def self.latest_few
    latest({ :limit => 5 })
  end

  def self.by_tag(tag)
    find_tagged_with(tag, :order => 'created_at DESC', :conditions => { :public => true })
  end

  def self.by_cookies(cookies)
    values = cookies.collect do |key, val|
      if key.match /ad_(.*)\z/
        $1
      end
    end.find_all {|item| !item.nil? }

    find_all_by_h(values, :conditions => { :user_id => nil, :public => true })
  end

  def photo_attributes=(photo_attributes)
    photo_attributes.each do |attributes|
      photos.build(attributes.merge(:title => 'xxx'))
    end
  end

  def remove
    self.public = false
    save
  end

  def self.public_count
    count(:conditions => { :public => true })
  end

  def self.count_by_tag(tag)
    tagged_with(tag.to_s, :conditions => { :public => true }).size
  end
end
