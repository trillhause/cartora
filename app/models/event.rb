class Event < ApplicationRecord
  validates :name, presence: true
  validates :host_id, presence: true
  validates :start_time, :end_time, presence: true
  validate :start_time_is_before_end_time

  belongs_to :host, class_name: 'User', foreign_key: :host_id

  private

  def start_time_is_before_end_time
    errors.add(:start_time, 'must be before end time') unless
      start_time.to_i < end_time.to_i
  end
end
