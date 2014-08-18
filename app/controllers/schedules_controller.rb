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
    days = available_days(from..to)

    # DB読み込み
    if params[:member_id]
      @members = Member.where(id: params[:member_id])
    else
      @members = Member.all.order(:order)
    end
    schedules_a = Schedule.where(date: days).to_a.map(&:serializable_hash)

    # 一覧表示用Hashを作成
    # 例: {:date=>Sun, 17 Aug 2014, :time=>0}
    #     =>{:schedules=>{1=>nil, 2=>nil, 3=>nil, 4=>nil, 5=>nil}, 
    #        :memos=>{1=>nil, 2=>nil, 3=>nil, 4=>nil, 5=>nil}},
    @disp_h = {}
    days.each do |d|
      TIMES_NAME.each_with_index do |t, t_idx|
        @disp_h[date: d, time: t_idx] = {schedules: {}, memos: {}}
        @members.each do |m|
          @disp_h[date: d, time: t_idx][:schedules][m.id] = nil
          @disp_h[date: d, time: t_idx][:memos][m.id]     = nil
        end
      end
    end
    #binding.pry

    # scheduleの値をHashに入れ込む
    # 例: {:date=>Sun, 17 Aug 2014, :time=>0}
    #     =>{:schedules=>{1=>nil, 2=>"○", 3=>"○", 4=>nil, 5=>nil}, 
    #        :memos=>{1=>nil, 2=>"メモ", 3=>"メモ", 4=>nil, 5=>nil}},
    schedules_a.each do |s|
      if d = @disp_h[date: s['date'], time: s['time']]
        d[:schedules][s['member_id']] = s['schedule']
        d[:memos][s['member_id']]     = s['memo']
      end
    end
    #binding.pry

    @times = TIMES_NAME
    @weekdays = WEEKDAYS_NAME
    @schedules_value = SCHEDULES_VALUE
    @from_yyyymm = from.strftime('%Y%m')
    # binding.pry
  end

  def edit
    index
    # from = get_from(params[:yyyymmdd].presence)
    # redirect_to index_path if from.nil?
    # to = get_to(from)

    # @schedules = Schedule.where(date: (from..to), member_id: params[:member_id])
    # @member = Member.where(id: params[:member_id]).first
    # @times = TIMES
    # @schedules_sel = SCHEDULES_SEL
    # @days = (from..to).to_a
    # @from = from.strftime('%Y%m')
    # binding.pry
  end

  private
  def get_from(arg)
    if arg.present?
      return nil unless /^\d{6}$/ === arg

      begin
        from = Time.parse(arg.to_s + '01').to_datetime.beginning_of_month
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
