class Bicycle::StatisticsController < Bicycle::ApplicationController
  def index
    @period = params[:period] || "daily"
    case @period
    when "hourly"
      @range = 7.days.ago..Time.now
      @visits = Ahoy::Visit.group_by_hour(:started_at, range: @range).count
    when "daily"
      @range = 1.month.ago..Time.now
      @visits = Ahoy::Visit.group_by_day(:started_at, range: @range).count
    when "weekly"
      @range = 1.year.ago..Time.now
      @visits = Ahoy::Visit.group_by_week(:started_at, range: @range).count
    when "monthly"
      @range = 5.years.ago..Time.now
      @visits = Ahoy::Visit.group_by_month(:started_at, range: @range).count
    end
    # Note: Ahoy::Event.page_id is a virtual column created from  Ahoy::Event.properties->>'page_id'
    @most_visited = Ahoy::Event.where(name: "Page view", time: @range).joins(:page).group(:page_id, :title, :template).select(:title, :template, "COUNT(ahoy_events.id) AS visits").order('visits desc').limit(10)
    @referrers = Ahoy::Visit.group(:referrer).where.not(referrer: nil).select(:referrer, "COUNT(ahoy_visits.id) AS referrals").order('referrals desc').limit(10)
    # Note: Ahoy::Visit.location is a virtual column created from Ahoy::Visit.country, region and city
    @locations = Ahoy::Visit.group(:location).where.not(location: nil).select(:location, "COUNT(ahoy_visits.id) AS visits").order('visits desc').limit(10)
    # TODO: Join landing pages from Ahoy::Visit to Pages
  end

  private
  def statistics_params
    params.permit(:period)
  end
end
