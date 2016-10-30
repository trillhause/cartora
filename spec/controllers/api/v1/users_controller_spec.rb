require 'rails_helper'
require 'api_constraints'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:each) { request.headers['Accept'] = "application/vnd.traveltime.v1"}

  describe "GET #show" do
    before(:each) do
        @user = FactoryGirl.create :user
        get :show, params: {id: @user.id}, format: :json
      end

    it "returns the information about a reporter on a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with :ok }
  end

  describe "POST #create" do
    context "when successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for  :user
        post :create, params: {user: @user_attributes}, format: :json
      end

      it "renders the json representation for the user record just created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { should respond_with :created }
    end

    context "when is not created" do
      before(:each) do
        @invalid_user_attributes = { password: "12345678",
                                     password_confirmation: "12345678" }
        post :create, params: {user: @invalid_user_attributes}, format: :json
      end

      it "renders an json error" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it "renders the json on why the user was not created" do
        user_response =JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with :unprocessable_entity }
    end
  end
end
