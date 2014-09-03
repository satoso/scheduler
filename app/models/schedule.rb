class Schedule < ActiveRecord::Base
  belongs_to :member
  enum time:         {morning: 0, afternoon: 1, evening: 2}
  enum availability: {no_answer: 0, ok: 1, pending: 2, ng: 3}
end
