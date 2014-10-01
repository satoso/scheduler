class SchedulesController < ApplicationController
  # TODO: DRY!!
  DEFAULT_DURATION_MONTHS = 1

  def index
    # 表示範囲を決める
    from = get_from(params[:yyyymm].presence)
    return redirect_to root_path if from.nil?  # return が必要
    to = get_to(from)
    @days = disp_days(from..to)

    @members = Member.all.order(:order)
    @schedules = Schedule.where(date: @days)

    @date_here = from
    @date_prev = from - DEFAULT_DURATION_MONTHS.month
    @date_next = from + DEFAULT_DURATION_MONTHS.month
  end

  def edit
    # 表示範囲を決める
    from = get_from(params[:yyyymm].presence)
    return redirect_to root_path if params[:yyyymm].nil?  # return が必要
    to = get_to(from)
    @days = disp_days(from..to)

    @members = Member.where(id: params[:member_id])

    @days.each do |d|
      Schedule.times.keys.each do |t|
        Schedule.find_or_create_by(
          date:          d,
          time:          t.to_sym,
          member_id:     @members.first.id,
          availability:  Schedule.availabilities[:no_answer],
          note:          '',
        )
      end
    end

    @schedules = Schedule.where(date: @days, member_id: @members.first.id)
  end

  def create
    Schedule.update(schedule_params.keys, schedule_params.values)
    redirect_to root_path
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

  def disp_days(range)
    range.to_a.select { |d| d.saturday? || d.sunday? }
  end

  def schedule_params
    params.require(:schedules).each do |k,v|
      ActionController::Parameters.new(v).permit(:availability, :note)
    end
  end
end
