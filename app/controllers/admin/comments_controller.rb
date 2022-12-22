class Admin::CommentsController < ApplicationController
  def destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    @comment = Comment.new
    redirect_to admin_post_path(@post.id)
  end

  private
  def comment_params
    params.require(:comment).permit(:comment)
  end
end
