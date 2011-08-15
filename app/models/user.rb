class User < Deadbolt::User

  attr_accessible :physician_id

  def physician=(object_or_id)
    id = object_or_id.class == Physician ? object_or_id.id : object_or_id
    update_attributes :physician_id => id
  end
end
