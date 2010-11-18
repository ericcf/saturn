class AdminsController < ApplicationController
  include SectionResourceController

  before_filter :authenticate_user!

  def show
    authorize! :manage, @section
    @section.create_admin_role
    @users = Deadbolt::User.all
  end

  def update
    authorize! :manage, @section
    administrator_ids = params[:admin_ids] ? params[:admin_ids].keys : []
    @section.update_attributes(:administrator_ids => administrator_ids)
    redirect_to section_admins_path(@section)
  end
end
