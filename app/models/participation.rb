class Participation < ApplicationRecord
  validates :user_id, :event_id, presence: true
  validates :user_id, uniqueness: { scope: :event_id }

  belongs_to :user
  belongs_to :event
end
