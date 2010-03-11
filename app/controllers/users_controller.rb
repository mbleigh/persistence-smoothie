class UsersController < ApplicationController
  def index
    @users = User.all(:order => :name)
  end
  
  def follow
    @user = User.find_by_id(params[:id])
    if @user && current_user.follow!(@user)
      flash[:notice] = "You are now following #{@user.name}."
    else
      flash[:error] = "Unable to follow #{@user.name}."
    end
    redirect_to :back
  end
  
  def show
    @user = User.find_by_id(params[:id])
    @followers = @user.followers
    @followings = @user.followings
    @friends = @user.friends
  end
end
