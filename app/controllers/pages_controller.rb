class PagesController < ApplicationController
  require "kramdown"
  require "rouge"
  prepend_before_action :authenticate_user!, only: %i[comment]
  before_action :set_page, only: %i[show comment]
  after_action :track_view, only: %i[index show]

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
    @comment = Comment.new(comment_params.merge(page_id: @page.id, user_id: current_user.id))
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

  def track_view
    # Admin users do not generate a visit
    if current_visit
      unless Ahoy::Event.where(name: "Page view", visit_id: current_visit.id).where_properties(page_id: @page.id).exists?
         ahoy.track("Page view", {page_id: @page.id, visit_id: current_visit.id})
      end
    end
  end

  def comment_params
    params.require(:comment).permit(:title, :body)
  end
end
