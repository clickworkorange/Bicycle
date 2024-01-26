# Use an alternative cache store:
#   ActiveJob::Status.store = :file_store, "/path/to/cache/directory"
#   ActiveJob::Status.store = :redis_cache_store, { url: ENV['REDIS_URL'] }
#   ActiveJob::Status.store = :mem_cache_store
#
# You should avoid using cache store that are not shared between web and background processes
# (ex: :memory_store).
#

ActiveJob::Status.store = :file_store, "tmp/cache" if Rails.cache.is_a?(ActiveSupport::Cache::NullStore)

# Apply a time interval in seconds between every status updates.
# Default is 0 - no throttling mechanism
#
ActiveJob::Status.options = {throttle_interval: 1}
