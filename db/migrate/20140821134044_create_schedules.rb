class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.date :date
      t.integer :time
      t.string :availability
      t.text :note
      t.references :member, index: true

      t.timestamps
    end
  end
end
