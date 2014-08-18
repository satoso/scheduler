class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.date :date
      t.integer :time
      t.string :schedule
      t.string :memo

      t.timestamps
    end
  end
end
