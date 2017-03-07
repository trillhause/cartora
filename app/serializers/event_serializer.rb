class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_time, :end_time
  has_one :location, serializer: LocationsSerializer
end
