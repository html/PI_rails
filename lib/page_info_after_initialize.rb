module PageInfoAfterInitialize
  def after_initialize
    if !self.page_info && self.to_param
      self.page_info = PageInfo.create(:item_type => self.class.to_s, :item_id => self, :page_id => ([self.class.to_s, self.to_param].join '-'))
    end

    if !PageInfo::page
      PageInfo::page = self.page_info
    end
  end
end
