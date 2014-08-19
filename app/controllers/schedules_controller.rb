class SchedulesController < ApplicationController
  DEFAULT_DURATION_MONTHS = 2
  TIMES_NAME = %w(朝 昼 夜)
  SCHEDULES_VALUE = %w(○ △ ×)
  WEEKDAYS_NAME = %w(日 月 火 水 木 金 土)

  def index
    # 表示範囲を決める
    from = get_from(params[:yyyymm].presence)
    return redirect_to root_path if from.nil?  # return が必要
    to = get_to(from)
    @days = available_days(from..to)
    @times_name = TIMES_NAME

    @members = Member.all.order(:order)
    @schedules = Schedule.where(date: @days)

    @schedules_value = SCHEDULES_VALUE
    @weekdays_name = WEEKDAYS_NAME
    @from_yyyymm = from.strftime('%Y%m')
    # binding.pry
  end

  def edit
    # 表示範囲を決める
    from = get_from(params[:yyyymm].presence)
    return redirect_to root_path if params[:yyyymm].nil?  # return が必要
    to = get_to(from)
    @days = available_days(from..to)
    @times_name = TIMES_NAME

    @members = Member.where(id: params[:member_id])

    @days.each do |d|
      @times_name.each_with_index do |t, t_idx|
        Schedule.find_or_create_by(
          date:      d,
          time:      t_idx,
          member_id: @members.first.id,
          schedule:  '',
          memo:      '',
        )
      end
    end
    @schedules = Schedule.where(date: @days, member_id: @members.first.id)

    @schedules_value = SCHEDULES_VALUE
    @weekdays_name = WEEKDAYS_NAME
    @from_yyyymm = from.strftime('%Y%m')
    binding.pry
  end

  private
  def get_from(arg)
    if arg.present?
      return nil unless /^\d{6}$/ === arg

      begin
        from = Time.parse(arg.to_s + '01').to_date.beginning_of_month
      rescue ArgumentError
        from = nil
      end
    else
      from = Time.zone.today.beginning_of_month
    end
    from
  end

  def get_to(from)
    (from + (DEFAULT_DURATION_MONTHS - 1).months).end_of_month
  end

  def available_days(range)
    days = []
    range.to_a.each do |d|
      days << d if d.saturday? || d.sunday?
    end
    days
  end

end
