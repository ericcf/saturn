class User < Deadbolt::User

  attr_accessible :physician_id

  validates_associated :physician
  validates :physician_id, :uniqueness => true, :allow_nil => true
end
