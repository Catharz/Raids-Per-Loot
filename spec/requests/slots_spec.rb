require 'spec_helper'

describe 'Slots' do
  describe 'GET /slots' do
    it 'responds with success' do
      get slots_path

      response.status.should be(200)
    end

    it 'assigns the slots to @slots' do
      slot = FactoryGirl.create(:slot)

      get slots_path

      assigns(:slots).should eq [slot]
    end

    it 'displays the slots name' do
      slot = FactoryGirl.create(:slot)

      visit slots_path

      response.body.should include slot.name
    end
  end
end
