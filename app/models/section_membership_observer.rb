class SectionMembershipObserver < ActiveRecord::Observer

  def after_create(section_membership)
    email = section_membership.physician.primary_email
    unless User.find_by_email(email)
      password = random_password
      User.create(:email => email,
        :password => password,
        :password_confirmation => password,
        :physician_id => section_membership.physician.id
      )
    end
  end

  private

  def random_password
    choices = ("a".."z").to_a.concat(("0".."9").to_a)
    (0..8).map { choices[rand(choices.size)] }.join('')
  end
end
