class Bicycle::PagesController < Bicycle::ApplicationController
  before_action :set_page, only: %i[ show edit update destroy ]

  def index
    @pages = Page.all
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

  private
    def set_page
      @page = Page.friendly.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:title, :abstract, :body, :live, :template, :parent_id)
    end
end
