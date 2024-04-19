class Bicycle::CommentsController < Bicycle::ApplicationController
  before_action :set_comment, only: %i[destroy]

  def index
    @comments = Comment.all.order(created_at: :desc) 
  end

  def show
  end

  def destroy
    @comment.destroy!
    redirect_to bicycle_comments_url, notice: "Comment was successfully deleted.", status: :see_other
  end

  private
  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment)
  end
end
