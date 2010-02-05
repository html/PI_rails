class Photo < ActiveRecord::Base
  has_attached_file :image, :storage => :filesystem, :styles => {
    :original => ["1024x768", :png],
    :half => ["240x240#", :jpg],
    :full => ["800x600", :jpg],
    :thumb => ["100x100#", :jpg]
  }
  validates_attachment_presence :image
  validates_presence_of :title

  def self.random
    first(:conditions => { :public => true }, :order => 'RANDOM()')
  end

  def self.all
    find(:all, :conditions => { :public => true })
  end
end
