require 'rails_helper'

RSpec.describe Api::V1::LocationsController, type: :controller do

  describe 'GET #show_event_location' do
    before(:each) do
      @user = FactoryGirl.create :user
      @event = FactoryGirl.create :event, host: @user
      api_authorization_header @user.auth_token
      get :show_event_location, params: { event_id: @event.id }
    end

    it 'returns the location of the event' do
      expect(json_response[:lat]).to eql @event.location.lat.to_s
      expect(json_response[:lng]).to eql @event.location.lng.to_s
    end

    it { should respond_with :ok }
  end

  describe 'GET #show_user_location' do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      get :show_user_location, params: { user_id: @user.id }
    end

    it 'returns the location of the event' do
      expect(json_response[:lat]).to eql @user.location.lat.to_s
      expect(json_response[:lng]).to eql @user.location.lng.to_s
    end

    it { should respond_with :ok }
  end
  
  describe 'GET #show_location_of_users_for_event' do
    context 'when successfully gets the result' do
      before :each do
        @user = FactoryGirl.create :user
        @event = FactoryGirl.create :event_with_participants, host: @user
        api_authorization_header @user.auth_token
        get :show_location_of_users_for_event, params: {event_id: @event.id}
      end

      it 'json response includes hosts location at first place' do
        expect(json_response[0][:id]).to eql @user.id
        expect(json_response[0][:location][:lat]).to eql @user.location.lat.round(6).to_s
        expect(json_response[0][:location][:lng]).to eql @user.location.lng.round(6).to_s
      end

      it 'json response includes location of all participants and host' do
        expect(json_response.count).to eql @event.users.size+1
      end

      it { should respond_with :ok }
    end

    context 'when event_id requested does not exist' do
      before :each do
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token
        get :show_location_of_users_for_event, params: {event_id: "34"}
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it { should respond_with :unprocessable_entity }
    end
  end

  describe 'POST #create_user_location' do
    context 'when is successfully created' do
      before :each do
        @user = FactoryGirl.create :user
        @user.location = nil
        @location_attributes = FactoryGirl.attributes_for :location
        api_authorization_header @user.auth_token
        post :create_user_location, params: @location_attributes.merge(user_id: @user.id)
      end

      it 'renders the json representation of the location' do
        expect(json_response[:lat]).to eql @location_attributes[:lat].round(6).to_s
        expect(json_response[:lng]).to eql @location_attributes[:lng].round(6).to_s
      end

      it { should respond_with :created }
    end

    context 'when is not successfully created' do
      before :each do
        @user = FactoryGirl.create :user
        @location_attributes = FactoryGirl.attributes_for :location
        api_authorization_header @user.auth_token
        post :create_user_location, params: @location_attributes.merge(user_id: @user.id)
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders an error message' do
        expect(json_response[:errors]).to eql "Location already exists, do a PUT to update location"
      end

      it { should respond_with :unprocessable_entity }
    end
  end

  describe 'PUT #update_user_location' do
    context 'when is successfully updates' do
      before :each do
        @user = FactoryGirl.create :user
        @location_attributes = FactoryGirl.attributes_for :location
        api_authorization_header @user.auth_token
        patch :update_user_location, params: @location_attributes.merge(user_id: @user.id)
      end

      it 'renders the json representation of the location' do
        expect(json_response[:lat]).to eql @location_attributes[:lat].round(6).to_s
        expect(json_response[:lng]).to eql @location_attributes[:lng].round(6).to_s
      end

      it { should respond_with :ok }
    end

    context 'when is not successfully updates' do
      before :each do
        @user = FactoryGirl.create :user
        @location_attributes = FactoryGirl.attributes_for :location
        @location_attributes[:lat] = "91.00"
        api_authorization_header @user.auth_token
        patch :update_user_location, params: @location_attributes.merge(user_id: @user.id)
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it { should respond_with :unprocessable_entity }
    end
  end

  describe 'PUT #update_user_location_with_response' do
    context 'when is successfully updates' do
      before :each do
        @user = FactoryGirl.create :user
        @location_attributes = FactoryGirl.attributes_for :location
        @event = FactoryGirl.create :event_with_participants, host: @user
        api_authorization_header @user.auth_token
        patch :update_user_location_with_response, params: @location_attributes.merge(user_id: @user.id, event_id: @event.id)
      end

      it 'json response includes hosts location at first place' do
        expect(json_response[0][:id]).to eql @user.id
        expect(json_response[0][:location][:lat]).to eql @user.location.lat.round(6).to_s
        expect(json_response[0][:location][:lng]).to eql @user.location.lng.round(6).to_s
      end

      it 'json response includes location of all participants and host' do
        expect(json_response.count).to eql @event.users.size+1
      end

      it { should respond_with :ok }
    end

    context 'when event_id requested does not exist' do
      before :each do
        @user = FactoryGirl.create :user
        @location_attributes = FactoryGirl.attributes_for :location
        api_authorization_header @user.auth_token
        patch :update_user_location_with_response, params: @location_attributes.merge(user_id: @user.id, event_id: "34")
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it { should respond_with :unprocessable_entity }
    end
  end
end