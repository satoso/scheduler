class AddMemberIdToSchedule < ActiveRecord::Migration
  def change
    add_column :schedules, :member_id, :integer
  end
end
