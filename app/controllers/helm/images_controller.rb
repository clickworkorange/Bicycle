class Helm::ImagesController < Helm::ApplicationController
  before_action :get_page
  before_action :set_image, only: %i[ show edit update destroy ]

  # GET /images
  def index
    @images = @page.images
  end

  # GET /images/1
  def show
  end

  # GET /images/new
  def new
    @image = @page.images.build
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  def create
    @image = @page.images.build(image_params)

    if @image.save
      redirect_to helm_page_images_path(@page), notice: "Image was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /images/1
  def update
    if @image.update(image_params)
      redirect_to helm_page_images_path(@page), notice: "Image was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /images/1
  def destroy
    @image.destroy!
    redirect_to helm_page_images_path(@page), notice: "Image was successfully destroyed.", status: :see_other
  end

  private
    def get_page
      @page = Page.friendly.find(params[:page_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = @page.images.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def image_params
      params.require(:image).permit(:image_file, :caption, :alt_text, :page_id)
    end
end
