require 'rails_helper'

RSpec.describe Participation, type: :model do
  let(:participation) { FactoryGirl.build :participation }
  subject { participation }

  it { should respond_to :user_id }
  it { should respond_to :event_id }
  it { should respond_to :attending }

  it { should be_valid }

  it { should belong_to(:user) }
  it { should belong_to(:event) }
end
