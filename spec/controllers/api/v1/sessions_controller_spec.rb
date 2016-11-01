require 'rails_helper'
require 'api_constraints'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe "POST #create" do
    before(:each) do
      @user = FactoryGirl.create :user
    end

    context "when the credentials are correct" do
      before(:each) do
        credentials = { email: @user.email, password: '12345678' }
        post :create, params: { sessions: credentials }
      end

      it "return the user record corresponding to the given credentials" do
        @user.reload
        expect(json_response[:auth_token]).to eql @user.auth_token
      end

      it { should respond_with :ok}
    end

    context "when the credentials are incorrect" do
      before(:each) do
        credentials = { email: @user.email, password: 'invalid password' }
        post :create, params: { sessions: credentials }
      end

      it "returns json with an error" do
        expect(json_response[:errors]).to eql "Invalid email or password"
      end

      it { should respond_with :unprocessable_entity }
    end

  end
end
