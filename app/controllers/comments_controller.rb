class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to :back, notice: 'ok'
    else
      render :new
    end
  end

  def update
  end

  def comment_params
    params.require(:comment).permit(:comment, :user_id, :bug_id)
  end
end
