class Group < DirectoryModel

  has_many :memberships
  has_many :people, :through => :memberships
  
end
