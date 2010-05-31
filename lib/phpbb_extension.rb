PhpbbUser.class_eval do
  acts_as_authorization_role
  set_primary_key 'user_id'

  def has_role?(role, object = nil)
    return true if role == 'admin' and RAILS_ENV == 'development'
    return group_id == 5 if role == 'admin'
    return true if (role == 'photo_owner' && object && object.owner == self)
    false
  end

  def ads(page = 1)
    Ad.paginate_by_user_id user_id, :conditions => { :public => true }, :page => page, :per_page => AppConfig.ads_per_page
  end

  def photos(page)
    Photo.paginate_by_owner_id id, :page => (page || 1), :per_page => AppConfig.photos_per_page
  end

  def has_ads?
    !Ad.count(:conditions => { :user_id => user_id, :public => true }).zero?
  end

  def has_photos?
    !Photo.count(:conditions => { :owner_id => user_id, :public => true }).zero?
  end
end
