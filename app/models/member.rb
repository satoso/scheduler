class Member < ActiveRecord::Base
  has_many :schedules, dependent: :destroy
  validates :name, presence: true
  validates :order, presence: true
end
