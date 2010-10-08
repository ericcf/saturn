class Membership < DirectoryModel

  belongs_to :person, :foreign_key => :contact_id
  belongs_to :group
end
