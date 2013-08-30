require 'spec_helper'

describe LootTypesController do
  describe 'routing' do

    it 'routes to #index' do
      get('/loot_types').should route_to('loot_types#index')
    end

    it 'routes to #new' do
      get('/loot_types/new').should route_to('loot_types#new')
    end

    it 'routes to #show' do
      get('/loot_types/1').should route_to('loot_types#show', id: '1')
    end

    it 'routes to #edit' do
      get('/loot_types/1/edit').should route_to('loot_types#edit', id: '1')
    end

    it 'routes to #create' do
      post('/loot_types').should route_to('loot_types#create')
    end

    it 'routes to #update' do
      put('/loot_types/1').should route_to('loot_types#update', id: '1')
    end

    it 'routes to #destroy' do
      delete('/loot_types/1').should route_to('loot_types#destroy', id: '1')
    end

  end
end
