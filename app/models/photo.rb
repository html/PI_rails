class Photo < ActiveRecord::Base
  has_one :point, :as => :item
  belongs_to :owner, :class_name => 'PhpbbUser'
  has_attached_file :image, :storage => :filesystem, :styles => {
    :original => ["1024x768", :png],
    :half => ["240x240#", :jpg],
    :full => ["640x480", :jpg],
    :thumb => ["100x100#", :jpg]
  }
  validates_attachment_presence :image
  #validates_presence_of :title

  def before_create
    self.public = true if self.public.nil?
  end

  def self.random
    first(:conditions => { :public => true }, :order => 'RANDOM()')
  end

  def self.all
    find(:all, :conditions => { :public => true })
  end

  def self.all_with_points
    find(:all, :include => :point, :conditions => { :public => true })
  end

  def self.paginate_with_points(page)
    paginate :page => (page || 1), :per_page => AppConfig.photos_per_page, :conditions => { :public => true }
  end

  def cords
    if point
      [point.lat, point.lng]
    end
  end
end
