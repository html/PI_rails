class PageInfo < ActiveRecord::Base
  cattr_accessor :page
  set_table_name :pages_info
  belongs_to_anything :column => :page_id
end
