class ChangeSchedulesAvailabilityType < ActiveRecord::Migration
  AVAILABILITIES = %w(‐ ○ △ ×)

  def up
    rename_column :schedules, :availability, :availability_string
    add_column :schedules, :availability, :integer
    Schedule.find_each do |s|
      s.update(availability: AVAILABILITIES.index(s.availability_string))
    end
    remove_column :schedules, :availability_string
  end

  def down
    add_column :schedules, :availability_string, :string
    Schedule.find_each do |s|
      s.update(availability_string: AVAILABILITIES[s[:availability] || 0])
    end
    remove_column :schedules, :availability
    rename_column :schedules, :availability_string, :availability
  end
end
