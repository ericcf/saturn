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
    if @section.update_attributes(:administrator_ids => administrator_ids)
      flash[:notice] = "Successfully updated admins"
    else
      flash[:error] = "Unable to update admins: #{@section.errors.full_messages.join(", ")}"
    end
    redirect_to section_admins_path(@section)
  end
end
