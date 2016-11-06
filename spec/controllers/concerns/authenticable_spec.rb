require 'rails_helper'

class Authentication
  include Authenticable
end

describe Authenticable do
  let(:authentication){ Authentication.new }
  subject { authentication }
end
