PhpbbUser.class_eval do
  acts_as_authorization_role

  def has_role?(role, object = nil)
    if role == 'admin'
      group_id == 5
    else
      false
    end
  end

  def ads
    Ad.find_all_by_user_id user_id
  end

  def has_ads?
    !Ad.count(:conditions => { :user_id => user_id }).zero?
  end
end
