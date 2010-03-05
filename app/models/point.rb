class Point < ActiveRecord::Base
  def save_with(params)
    begin
      self.lat = params[:lat]
      self.lng = params[:lng]
      save
    rescue
      false
    end
  end
end
