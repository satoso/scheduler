class Member < ActiveRecord::Base
  has_many :schedules, dependent: :destroy
end
