class EventWithParticipantsSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_time, :end_time
  has_one :location, serializer: LocationsSerializer
  has_one :host, serializer: UserPublicSerializer
  has_many :users, key: 'participants', serializer: UserPublicSerializer
end
