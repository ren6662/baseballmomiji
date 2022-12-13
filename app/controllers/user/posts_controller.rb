class User::PostsController < ApplicationController
  def index
    @post = Post.all
  end
  
  def new
    @post = Post.new
  end
  
  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_prams)
    @post.user_id = current_user.id
    if @post.save
     redirect_to user_posts_path, notice: "投稿しました"
    else
      @posts = Post.all
      render "new"
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to user_posts_path, notice: "編集しました"
    else
      render "edit"
    end
  end

  def destroy
  end

  private

  def post_prams
    params.require(:post).permit(:title,:body,:image)
  end

end
