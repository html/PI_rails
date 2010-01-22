class PageInfo < ActiveRecord::Base
  cattr_accessor :page
  set_table_name :pages_info
end
