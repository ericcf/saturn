class PhysicianAliasesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_physician

  def new
    @physician_alias = PhysicianAlias.new
  end

  def create
    @physician_alias = @physician.build_names_alias(params[:physician_alias])

    if @physician_alias.save
      flash[:notice] = "Successfully created alias"
      return(redirect_to physicians_path)
    end
    render :new
  end

  def edit
    @physician_alias = @physician.names_alias
  end

  def update
    @physician_alias = @physician.names_alias

    if @physician_alias.update_attributes(params[:physician_alias])
      flash[:notice] = "Successfully updated alias"
      return(redirect_to physicians_path)
    end
    render :edit
  end

  private

  def find_physician
    physician_id = params[:physician_id]
    return(redirect_to(physicians_path)) unless physician_id
    @physician = Physician.find(physician_id)
  end
end
