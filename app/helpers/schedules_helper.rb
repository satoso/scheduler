module SchedulesHelper
  TIME_NAMES = {
    'morning'   => '朝',
    'afternoon' => '昼',
    'evening'   => '夜'
  }
  WEEKDAY_NAMES = %w(日 月 火 水 木 金 土)
  AVAILABILITY_VALUES = {
    'no_answer' => '‐',
    'ok'        => '○',
    'pending'   => '△',
    'ng'        => '×'
  }

  def weekday_name(date)
    WEEKDAY_NAMES[date.wday] || ''
  end

  def time_name(time)
    TIME_NAMES[time.to_s] || ''
  end

  def availability_value(avty)
    AVAILABILITY_VALUES[avty.to_s] || ''
  end

  def find_schedule_entry(schedules, date, time, member_id)
    schedules.find { |s|
      s.date == date && s.time == time && s.member_id == member_id
    }
  end

  def find_schedule_availability(schedules, date, time, member_id)
    avty = find_schedule_entry(schedules, date, time, member_id).try(:availability)
    availability_value(avty)
  end

  def build_notes(schedules, date, time, members)
    notes = []
    schedules.find_all { |s| s.date == date && s.time == time }.each do |s|
      unless s.note.blank?
        notes << {note: s.note, member: members.find { |m| m.id == s.member_id }.name}
      end
    end
    notes
  end

  def availabilities_ordered
    Schedule.availabilities
      .sort {|a,b| a[1]<=>b[1]}
      .map  {|a|   a[0]} - ['no_answer'] << 'no_answer'
  end
end
