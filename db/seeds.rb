# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#require 'date'

(1..5).each do |n|
  Member.create(name: 'メンバ' + n.to_s, order: n)
end

(1..5).each do |n|
  Member.find(n).schedules << Schedule.create(date: n.days.from_now,     time: 0, schedule: '○', memo: 'メモ')
  Member.find(n).schedules << Schedule.create(date: (n+1).days.from_now, time: 0, schedule: '○', memo: 'メモ')
  Member.find(n).schedules << Schedule.create(date: (n+1).days.from_now, time: 1, schedule: '×', memo: 'メモ')
  Member.find(n).schedules << Schedule.create(date: (n+2).days.from_now, time: 2, schedule: '○', memo: 'メモ')
  Member.find(n).schedules << Schedule.create(date: (n+4).days.from_now, time: 0, schedule: '○', memo: 'メモ')
end

