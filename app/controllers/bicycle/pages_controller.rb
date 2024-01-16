class Bicycle::PagesController < Bicycle::ApplicationController
  before_action :set_page, only: %i[ show edit update destroy move toggle ]

  def index
    @pages = Page.roots
  end

  def show
  end

  def new
    @page = Page.build
  end

  def edit
  end

  def create
    @page = Page.new(page_params)

    if @page.save
      redirect_to edit_bicycle_page_path(@page), notice: "Page was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @page.update(page_params)
      redirect_to edit_bicycle_page_path(@page), notice: "Page was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @page.destroy!
    redirect_to bicycle_pages_url, notice: "Page was successfully deleted.", status: :see_other
  end

  def move
    if params[:dir] == "up"
      @page.move_left
    elsif params[:dir] == "dn"
      @page.move_right
    end
    redirect_to bicycle_pages_url
  end

  def toggle
    if @page.live && @page.children.any? 
      @page.descendants.update_all({live: false})
    end
    @page.update({live: @page.live.!})
    redirect_to bicycle_pages_url
  end

  private
    def set_page
      @page = Page.friendly.find(params[:id] || params[:page_id])
    end

    def page_params
      params.require(:page).permit(:title, :abstract, :body, :live, :template, :parent_id)
    end
end
