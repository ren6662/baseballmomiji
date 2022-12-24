class User::UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @current_entry = Entry.where(user_id: current_user.id)
    @another_entry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @current_entry.each do |current|
        @another_entry.each do |another|
          if current.room_id == another.room_id
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def favorites
    @user = User.find(params[:id])
    favorites= Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end

  def update
   @user = current_user
    if @user.update(user_params)
      redirect_to user_users_path, notice: "編集しました"
    else
      render "edit"
    end
  end
  
  def withdrawal
    @user = User.find(params[:id])
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end
  
  def unsubscribe
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :is_deleted, :image)
  end

  def set_user
    @user = User.find(params[:id])
  end
  
  # 会員の論理削除のための記述。
    def reject_user
      @user = User.find_by(name: params[:user][:name])
      if @user 
        if @user.valid_password?(params[:user][:password]) && (@user.is_deleted == false)
          flash[:notice] = "退会済みです。再度ご登録をしてご利用ください。"
          redirect_to new_user_registration
        else
          flash[:notice] = "項目を入力してください"
        end
      end
    end
    
    def set_user
      @user = User.find(params[:id])
    end
end
