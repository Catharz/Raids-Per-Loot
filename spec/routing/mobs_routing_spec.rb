require 'spec_helper'

describe MobsController do
  describe 'routing' do

    it 'routes to #index' do
      get('/mobs').should route_to('mobs#index')
    end

    it 'routes to #new' do
      get('/mobs/new').should route_to('mobs#new')
    end

    it 'routes to #show' do
      get('/mobs/1').should route_to('mobs#show', id: '1')
    end

    it 'routes to #edit' do
      get('/mobs/1/edit').should route_to('mobs#edit', id: '1')
    end

    it 'routes to #create' do
      post('/mobs').should route_to('mobs#create')
    end

    it 'routes to #update' do
      put('/mobs/1').should route_to('mobs#update', id: '1')
    end

    it 'routes to #destroy' do
      delete('/mobs/1').should route_to('mobs#destroy', id: '1')
    end

  end
end
