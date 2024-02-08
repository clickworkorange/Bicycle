class PagesController < ApplicationController
  require "kramdown"
  require "rouge"
  prepend_before_action :authenticate_user!, only: %i[comment]
  before_action :set_page, only: %i[show comment]

  def index
    @page = Page.for_url("/").first
    if @page
      render @page.template, locals: {page: @page}
    else
      render_404
    end
  end

  def show
    if @page
      unless @page.live || current_user&.admin
        flash[:alert] = t("no_access")
        redirect_to root_path
      end
      @comment = Comment.build
      render @page.template, locals: {page: @page}
    else
      render_404
    end
  end

  def comment
    @comment = Comment.new(comment_params)
    @comment.page_id = @page.id
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to page_path(@page, anchor: "comment-#{@comment.id}"), notice: t("comment.thank_you")
    else
      flash[:alert] = t("comment.failed")
      render @page.template, locals: {page: @page}
    end
  end

  private
  def set_page
    @page = Page.friendly.find(params[:id], allow_nil: true) || Page.for_url("/#{params[:id]}").first
  end

  def comment_params
    params.require(:comment).permit(:title, :body, :page_id)
  end
end
