class Location < ApplicationRecord
  validates :lat, :lng, presence: true
  validate :coordinates_are_within_bounds

  belongs_to :area, polymorphic: true

  private

  def coordinates_are_within_bounds
    errors.add(:lat, 'must be between -90 and +90') unless lat && lat.between?(-90,90)
    errors.add(:lng, 'must be between -180 and +180') unless lng && lng.between?(-180,180)
  end
end