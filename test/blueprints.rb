require 'machinist/active_record'

correct_image = File.open(File.dirname(__FILE__) + '/fixtures/correct_image.png')

Photo.blueprint do
  title 'Test'
  image correct_image
end

PhpbbUser.class_eval do
  establish_connection 'test'

  def user_id
    id
  end
end

Ad.blueprint do
  title 'test'
  content 'test'
  contacts 'test'
  tag_list 'asdf'
end

Article.blueprint do
  
end

PhpbbUser.blueprint do |b|
  b.group_id 1
end

