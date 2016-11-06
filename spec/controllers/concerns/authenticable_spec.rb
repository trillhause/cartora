require 'rails_helper'

class Authentication
  include Authenticable
end

describe Authenticable do
  let(:authentication){ Authentication.new }
  subject { authentication }

  describe '#user_signed_in?' do
    context 'when there is a user on session' do
      before do
        @user = FactoryGirl.create :user
        allow(authentication).to receive(:current_user).and_return(@user)
      end

      it { should be_user_signed_in }
    end

    context 'when there is no user on session' do
      before do
        @user = FactoryGirl.create :user
        allow(authentication).to receive(:current_user).and_return(nil)
      end

      it { should_not be_user_signed_in }
    end
  end
end
