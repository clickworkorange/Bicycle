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
    @most_visited = Ahoy::Event.where(name: "Page view", time: @range).joins(:page).group(:page_id, :title, :template).select(:title, :template, "COUNT(ahoy_events.id) AS visits").order('visits desc').limit(10)
    @referrers = Ahoy::Visit.group(:referrer).where.not(referrer: nil).select(:referrer, "COUNT(ahoy_visits.id) AS referrals")
    # TODO: Join landing pages from Ahoy::Visit to Pages
  end

  private
  def statistics_params
    params.permit(:period)
  end
end
