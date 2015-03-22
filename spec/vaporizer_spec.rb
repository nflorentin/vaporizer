require 'spec_helper'

describe Vaporizer do
  it { expect(Vaporizer).to respond_to(:configure) }

  context "after configure" do
    before :all do
      Vaporizer.configure do |config|
      end
    end

    it { expect(Vaporizer.config).to respond_to(:app_key) }
    it { expect(Vaporizer.config).to respond_to(:app_id) }
  end
end
