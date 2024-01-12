class Helm::PagesController < Helm::ApplicationController
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
      redirect_to edit_helm_page_path(@page), notice: "Page was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # TODO: drop banner and use Image instead
    # if params[:banner_delete] & @page.banner.attached?
    #   @page.banner.purge
    # end
    if @page.update(page_params)
      redirect_to edit_helm_page_path(@page), notice: "Page was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @page.destroy!
    redirect_to helm_pages_url, notice: "Page was successfully deleted.", status: :see_other
  end

  private
    def set_page
      @page = Page.friendly.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:live, :title, :abstract, :body, :parent_id, :banner, :banner_delete)
    end
end
