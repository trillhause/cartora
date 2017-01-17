class Event < ApplicationRecord
  validates :name, presence: true
  validates :host_id, presence: true
  validates :start_time, :end_time, presence: true
  validate :start_time_is_before_end_time

  has_many :users, through: :participations
  has_many :participations, dependent: :destroy
  has_many :attending, -> { where(attending: true) }, :class_name => 'Participation'
  has_many :invited, -> { where(attending: false) }, :class_name => 'Participation'
  belongs_to :host, class_name: 'User', foreign_key: :host_id
  has_one :location, as: :area, dependent: :destroy

  private

  def start_time_is_before_end_time
    errors.add(:start_time, 'must be before end time') if
      start_time && end_time && !(start_time < end_time)
  end
end
