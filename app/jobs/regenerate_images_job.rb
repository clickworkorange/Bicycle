class RegenerateImagesJob < ApplicationJob
  include ActiveJob::Status
  queue_as :default
  after_perform :done

  def perform(*args)
    status[:status] = :working
    progress.total = Image.count
    Image.all.each do |image| 
      image.image_file.recreate_versions!
      progress.increment
    end
  end

  private
  def done
    status[:status] = :done
    puts "IMAGES REGENERATED!"
  end
end
