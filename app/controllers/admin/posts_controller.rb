class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @post = Post.all
    @tag_list=Tag.all
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
    @post_tags = @post.tags
    @comments = @post.comments
  end

  def edit
    @post = Post.find(params[:id])
    @post.set_tag
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to request.referer, notice: "投稿しました"
    else
      @posts = Post.all
      render :new
#      redirect_to request.referer
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to admin_posts_path, notice: "編集しました"
    else
      render "edit"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title,:body,:imag,:tag)
  end
end
