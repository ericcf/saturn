class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def update_roles
    if params[:users]
      params[:users].each do |user_id, attributes|
        if User.exists?(user_id) && attributes.include?(:admin)
          User.find(user_id).update_attribute(:admin, attributes[:admin])
        end
      end
    end

    redirect_to users_path
  end
end
