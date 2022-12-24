class User::PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.page(params[:page]).per(8)
    @tag_list=Tag.all
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @comment = current_user.comments.new
    @post_tags = @post.tags
  end

  def edit
    @post = Post.find(params[:id])
    @post.set_tag
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to user_posts_path(@post), notice: "投稿しました"
    else
      @posts = Post.all
      render :new
#      redirect_to request.referer
    end
  end

  def update
    @post = Post.find(params[:id])
    @post.touch
    if @post.update(post_params)
      redirect_to user_posts_path, notice: "編集しました"
    else
      render "edit"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_posts_path
  end


  private

  def post_params
    params.require(:post).permit(:title,:body,:image,:tag)
  end

end
