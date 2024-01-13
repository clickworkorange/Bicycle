class Helm::ImagesController < Helm::ApplicationController
  before_action :get_page
  before_action :set_image, only: %i[ show edit update destroy ]
  
  # TODO: "role"? (e.g. "banner")

  def index
    @images = @page.images
  end

  def show
  end

  def new
    @image = @page.images.build
  end

  def edit
  end

  def create
    @image = @page.images.build(image_params)

    if @image.save
      redirect_to helm_page_images_path(@page), notice: "Image was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @image.update(image_params)
      redirect_to helm_page_images_path(@page), notice: "Image was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @image.destroy!
    redirect_to helm_page_images_path(@page), notice: "Image was successfully destroyed.", status: :see_other
  end

  private
    def get_page
      @page = Page.friendly.find(params[:page_id])
    end

    def set_image
      @image = @page.images.find(params[:id])
    end

    def image_params
      params.require(:image).permit(:image_file, :role, :caption, :alt_text, :page_id)
    end
end
