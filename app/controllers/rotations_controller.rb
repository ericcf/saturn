class RotationsController < ApplicationController

  before_filter :authenticate_user!
  before_filter { authorize! :manage, Rotation }

  def index
    @rotations = Rotation.all
  end

  def new
    @rotation = Rotation.new
  end

  def create
    @rotation = Rotation.new(params[:rotation])

    if @rotation.save
      return(redirect_to rotations_path)
    end
    render :new
  end

  def edit
    @rotation = Rotation.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested rotation not found"
    redirect_to rotations_path
  end

  def update
    @rotation = Rotation.find(params[:id])

    if @rotation.update_attributes(params[:rotation])
      return(redirect_to rotations_path)
    end
    render :edit

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested rotation not found"
    redirect_to rotations_path
  end

  def destroy
    @rotation = Rotation.find(params[:id])

    if @rotation.destroy
      flash[:notice] = "Successfully deleted rotation"
    else
      flash[:error] = "Error: failed to delete rotation"
    end
    return(redirect_to rotations_path)

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested rotation not found"
    redirect_to rotations_path
  end
end
