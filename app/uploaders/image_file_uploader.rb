class ImageFileUploader < CarrierWave::Uploader::Base
  include CarrierWave::Vips
  storage :file
  process :store_dimensions

  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  # TODO: find out why conditional versions do not work
  # TODO: https://github.com/carrierwaveuploader/carrierwave/wiki/how-to:-secure-upload
  # TODO: limit aspect ratios to a predefined list by cropping to closest match:
  # 2.33 = 2.33/1
  # 1.77 = 16/9
  # 1.60 = 16/10
  # 1.50 = 3/2
  # 1.33 = 4/3
  # 1.00 = 1/1
  # 0.75 = 3/4
  # 0.66 = 2/3
  # 0.63 = 10/16
  # 0.56 = 9/16

  version :thumb do
    process resize_to_fit: [240, 240]
  end

  version :square do
    process resize_to_fill: [260, 260]
    process crop: [10, 10, 240, 240]
  end

  version :small do # , if: :not_banner? do
    process resize_to_fit: [600, 600]
  end

  version :medium do # , if: :not_banner? do
    process resize_to_fit: [800, 800]
  end

  version :large do # , if: :not_banner? do
    # TODO: just copy original file if smaller
    process resize_to_limit: [1200, 1200]
  end

  version :small_banner do # , if: :banner? do
    process resize_to_fill: [320, 140]
  end

  version :medium_banner do # , if: :banner? do
    process resize_to_fill: [600, 160]
  end

  version :large_banner do # , if: :banner? do
    process resize_to_fill: [900, 250]
  end

  version :twitter do # , if: :banner? do
    process resize_to_fill: [1024, 512]
  end

  version :facebook do # , if: :banner? do
    process resize_to_fill: [1200, 630]
  end

  def banner?
    model.role == "banner"
  end

  def not_banner?
    model.role != "banner"
  end

  def store_dimensions
    model.width, model.height = ::Vips::Image.new_from_file(file.file).size
    model.aspect = calc_aspect(model.width, model.height)
  end

  def calc_aspect(numerator, denominator)
    swap = false
    if numerator < denominator
      # swap places
      numerator, denominator = denominator, numerator
      # TODO: get rid of the "swap" flag, it is ugly
      swap = true
    end
    if numerator < 2 || denominator < 2
      numerator *= 10
      denominator *= 10
    end
    gcd = numerator.gcd(denominator)

    if numerator === denominator
      "1/1"
    elsif swap
      "#{denominator / gcd}/#{numerator / gcd}"
    else
      "#{numerator / gcd}/#{denominator / gcd}"
    end
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    # "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    "images/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg"
  # end
end
