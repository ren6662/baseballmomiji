class User::UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
    @post = Post.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def favorites
    @user = User.find(params[:id])
    favorites= Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :introduction, :is_deleted)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
end
