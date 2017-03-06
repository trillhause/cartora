class Api::V1::LocationsController < ApplicationController
  before_action :authenticate_with_token!

  def show_event_location
    if location = Location.find_by(area_id: params[:event_id], area_type: 'Event')
      render json: location,
             serializer: LocationsSerializer,
             status: :ok
    else
      render json: { errors: "no location for this event yet" },
             status: :unprocessable_entity
    end
  end

  def show_user_location
    render json: current_user.location,
           serializer: LocationsSerializer,
           status: :ok
  end

  def show_location_of_users_for_event
    if event = Event.find_by(id: params[:event_id])
      render json: [event.host] | event.users,
             include:  'location',
             status: :ok,
             location: api_user_location_path(current_user, location),
             each_serializer: UserLocationSerializer
    else
      render json: { errors: "Event with id #{params[:event_id]} does not exist"},
             status: :unprocessable_entity

    end
  end

  def create_user_location
    return render json: { errors: "Location already exists, do a PUT to update location"},
                  status: :unprocessable_entity if current_user.location
    location = current_user.build_location(location_params)
    if location.save
      render json: location,
             status: :created,
             location: api_user_location_path(current_user, location),
             serializer: LocationsSerializer
    else
      render json: { errors: location.errors },
             status: :unprocessable_entity
    end
  end

  def update_user_location
    if current_user.location
      location = current_user.location
    else
      location = current_user.build_location(location_params)
    end

    if location.update(location_params)
      render json: location,
             status: :ok,
             location: api_user_location_path(current_user, location),
             serializer: LocationsSerializer
    else
      render json: { errors: location.errors },
             status: :unprocessable_entity
    end
  end

  def update_user_location_with_response
    if location = current_user.location
      if location.update(location_params)
        if event = Event.find_by(id: params[:event_id])
          render json: [event.host] | event.users,
                 include:  'location',
                 status: :ok,
                 location: api_user_location_path(current_user, location),
                 each_serializer: UserLocationSerializer
        else
          render json: { errors: "Event with id #{params[:event_id]} does not exist"},
                 status: :unprocessable_entity
        end
      else
        render json: { errors: location.errors },
               status: :unprocessable_entity
      end
    else
      render json: { errors: "Please enable location services"},
             status: :unprocessable_entity
    end
  end

  private

  def location_params
    params.permit(:lat, :lng)
  end
end