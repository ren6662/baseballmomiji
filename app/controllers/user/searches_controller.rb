class User::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]

    if @range == "User"
      @users = User.looks(params[:search], params[:word])
      render "user/searches/search_result"
    else
      @posts = Post.looks(params[:search], params[:word])
      render "user/searches/search_result"
    end
  end
end
