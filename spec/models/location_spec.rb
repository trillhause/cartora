require 'rails_helper'

RSpec.describe Location, type: :model do

  context 'User Location' do
    before { @location = FactoryGirl.build(:location, area:FactoryGirl.build(:user) ) }
    subject { @location }

    it { should respond_to :lat }
    it { should respond_to :lng }
    it { should respond_to :area_id }
    it { should respond_to :area_type }

    describe 'when lat is invalid' do
      before do
        @location.lat = 91.00
      end
      it { should be_invalid }
    end

    describe 'when lng is invalid' do
      before do
        @location.lat = 181.00
      end
      it { should be_invalid }
    end
  end

end