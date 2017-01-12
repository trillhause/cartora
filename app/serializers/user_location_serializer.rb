class UserLocationSerializer < ActiveModel::Serializer
  attributes :id
  has_one :location, serializer: LocationsSerializer
end
