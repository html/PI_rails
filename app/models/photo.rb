class Photo < ActiveRecord::Base
  has_attached_file :image, :storage => :filesystem, :styles => {
    :original => ["1024x768", :png],
    :thumb => ["100x100#", :png]
  }
  validates_attachment_presence :image
  validates_presence_of :title

  def self.random
    first(:order => 'RANDOM()')
  end
end
