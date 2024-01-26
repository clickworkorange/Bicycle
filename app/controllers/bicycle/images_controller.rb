class Bicycle::ImagesController < Bicycle::ApplicationController
  before_action :set_page, except: %i[regenerate]
  before_action :set_image, only: %i[show edit update destroy]

  def regenerate
    return unless request.post?

    job = RegenerateImagesJob.perform_later
    redirect_to bicycle_images_regenerate_path(job_id: job.job_id)
  end

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
      redirect_to edit_bicycle_page_path(@page), notice: "Image was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @image.update(image_params)
      redirect_to edit_bicycle_page_path(@page), notice: "Image was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @image.destroy!
    redirect_to edit_bicycle_page_path(@page), notice: "Image was successfully destroyed.", status: :see_other
  end

  private
  def set_page
    @page = Page.friendly.find(params[:page_id])
  end

  def set_image
    @image = @page.images.find(params[:id])
  end

  def image_params
    params.require(:image).permit(:image_file, :role, :caption, :alt_text, :page_id)
  end
end
