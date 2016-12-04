require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :controller do

  describe 'GET #show' do
    before(:each) do
      @user = FactoryGirl.create :user
      @event = FactoryGirl.create :event, host: @user
      get :show, params: { id: @event.id }
    end

    it "returns the information about a reporter on a hash" do
      expect(json_response[:name]).to eql @event.name
    end

    it { should respond_with :ok }
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before :each do
        @user = FactoryGirl.create :user
        @event_attributes = FactoryGirl.attributes_for :event
        api_authorization_header @user.auth_token
        post :create, params: { user_id: @user.id, event: @event_attributes }
      end

      it 'renders the json representation for the event record just created' do
        expect(json_response[:name]).to eql @event_attributes[:name]
      end

      it { should respond_with :created }
    end

    context 'when is not created' do
      before :each do
        @user = FactoryGirl.create :user
        @invalid_event_attributes = { name: "test", start_time: "invalid", end_time: "invalid" }
        api_authorization_header @user.auth_token
        post :create, params: { user_id: @user.id, event: @invalid_event_attributes }
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it { should respond_with :unprocessable_entity }
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      @user = FactoryGirl.create :user
      @event = FactoryGirl.create :event, host: @user
      api_authorization_header @user.auth_token
    end

    context 'when is successfully updated' do
      before(:each) do
        patch :update, params: { user_id: @user.id, id: @event.id, event: { name: "Drake's Birthday" } }
      end

      it 'renders the json representation for the updated user' do
        expect(json_response[:name]).to eql "Drake's Birthday"
      end

      it { should respond_with :ok }
    end

    context 'when is not updated' do
      before(:each) do
        patch :update, params: { user_id: @user.id, id: @event.id, event: { start_time: @event.end_time + 1.hour } }
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it { should respond_with :unprocessable_entity }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      @event = FactoryGirl.create :event, host: @user
      api_authorization_header @user.auth_token
      delete :destroy, params: { user_id: @user.id, id: @event.id }
    end

    it { should respond_with :no_content }
  end
end
