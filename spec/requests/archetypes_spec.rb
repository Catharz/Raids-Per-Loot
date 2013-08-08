require 'spec_helper'

describe 'Archetypes' do
  describe 'GET /archetypes' do
    it 'responds with success' do
      get archetypes_path

      response.status.should be(200)
    end

    it 'assigns the archetypes to @archetypes' do
      archetype = FactoryGirl.create(:archetype)

      get archetypes_path

      assigns(:archetypes).should include archetype
    end

    it 'displays the archetypes name' do
      archetype = FactoryGirl.create(:archetype)

      visit archetypes_path

      response.body.should include archetype.name
    end
  end
end
