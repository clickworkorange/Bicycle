class RegenerateImagesJob < ApplicationJob
  include ActiveJob::Status
  queue_as :default
  after_perform :done

  # TODO: we should prevent this job from being started while another instance is running

  def perform
    status[:status] = :working
    progress.total = Image.count
    # TODO: increment never reaches total?
    Image.all.each do |image|
      image.image_file.recreate_versions!
      progress.increment
    end
  end

  private
  def done
    status[:status] = :done
  end
end
