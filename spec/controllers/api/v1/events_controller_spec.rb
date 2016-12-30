require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :controller do

  describe 'GET #show' do
    before(:each) do
      @user = FactoryGirl.create :user
      @event = FactoryGirl.create :event, host: @user
      api_authorization_header @user.auth_token
      get :show, params: { user_id: @user.id ,id: @event.id }
    end

    it 'returns the information about event' do
      expect(json_response[:name]).to eql @event.name
    end

    it { should respond_with :ok }
  end

  describe 'GET #index' do
    before(:each) do
      @user = FactoryGirl.create :user
      2.times { FactoryGirl.create :event, host: @user }
      2.times { FactoryGirl.create :participation, user: @user }
      api_authorization_header @user.auth_token
      get :index, params: { user_id: @user.id }
    end

    it 'renders response with correct from the database' do
      expect(json_response.count).to eq(4)
    end
  end

  describe 'GET #hosting' do
    before(:each) do
      @user = FactoryGirl.create :user
      4.times { FactoryGirl.create :event, host: @user }
      api_authorization_header @user.auth_token
      get :hosting, params: { user_id: @user.id }
    end

    it 'renders response with correct from the database' do
      expect(json_response.count).to eq(4)
    end
  end

  describe 'GET #attending' do
    before(:each) do
      @user = FactoryGirl.create :user
      4.times { FactoryGirl.create :participation, user: @user }
      @user.participations.each do |p|
        p.update(attending: true)
      end
      api_authorization_header @user.auth_token
      get :attending, params: { user_id: @user.id }
    end

    it 'renders response with correct from the database' do
      expect(json_response.count).to eq(4)
    end
  end

  describe 'GET #invited' do
    before(:each) do
      @user = FactoryGirl.create :user
      4.times { FactoryGirl.create :participation, user: @user }
      api_authorization_header @user.auth_token
      get :invited, params: { user_id: @user.id }
    end

    it 'renders response with correct from the database' do
      expect(json_response.count).to eq(4)
    end
  end

  describe 'POST #create' do
    context 'when is successfully created with participants' do
      before :each do
        @user = FactoryGirl.create :user
        p1 = FactoryGirl.create :user
        p2 = FactoryGirl.create :user
        @event_attributes = FactoryGirl.attributes_for :event, participants: [ {id: p1.id} ,{id: p2.id} ]
        api_authorization_header @user.auth_token
        post :create, params: @event_attributes.merge(user_id: @user.id)
      end

      it 'renders the json representation for the event record' do
        expect(json_response[:name]).to eql @event_attributes[:name]
      end

      it 'renders the two participants in the response' do
        expect(json_response[:participants].count).to eql 2
      end

      it { should respond_with :created }
    end

    context 'when is successfully created without participants' do
      before :each do
        @user = FactoryGirl.create :user
        @event_attributes = FactoryGirl.attributes_for :event
        api_authorization_header @user.auth_token
        post :create, params: @event_attributes.merge(user_id: @user.id)
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
        post :create, params: @invalid_event_attributes.merge(user_id: @user.id)
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
        patch :update, params: { user_id: @user.id, id: @event.id, name: "Drake's Birthday" }
      end

      it 'renders the json representation for the updated user' do
        expect(json_response[:name]).to eql "Drake's Birthday"
      end

      it { should respond_with :ok }
    end

    context 'when participants of the events are successfully updated' do
      before(:each) do
        @p1 = FactoryGirl.create :user
        @p2 = FactoryGirl.create :user
        patch :update, params: { user_id: @user.id, id: @event.id, participants: [ {id: @p1.id} ,{id: @p2.id} ] }
      end

      it 'renders the event with two new participants' do
        expect(json_response[:participants].count).to eql 2
      end

      it 'renders the the correct information for the participants' do
        expect(json_response[:participants].find { |user| user[:id] == @p1.id }).to_not be_nil
        expect(json_response[:participants].find { |user| user[:id] == @p2.id }).to_not be_nil
      end

      it { should respond_with :ok }
    end

    context 'when is not updated' do
      before(:each) do
        patch :update, params: { user_id: @user.id, id: @event.id, start_time: @event.end_time + 1.hour }
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
