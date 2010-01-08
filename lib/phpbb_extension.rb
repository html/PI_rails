PhpbbUser.class_eval do
  acts_as_authorization_role

  def has_role?(role, object = nil)
    if role == 'admin'
      group_id == 5
    else
      false
    end
  end
end
