class Link < ActiveRecord::Base
  validates_presence_of :value, :message => 'не може бути пустим'
  before_create :set_default_values

  def set_default_values
    self.public = false
    true
  end

  def self.all
    find(:all, :conditions => { :public => true })
  end
end
