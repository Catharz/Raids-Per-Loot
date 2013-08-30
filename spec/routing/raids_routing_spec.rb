require 'spec_helper'

describe RaidsController do
  describe 'routing' do

    it 'routes to #index' do
      get('/raids').should route_to('raids#index')
    end

    it 'routes to #new' do
      get('/raids/new').should route_to('raids#new')
    end

    it 'routes to #show' do
      get('/raids/1').should route_to('raids#show', id: '1')
    end

    it 'routes to #edit' do
      get('/raids/1/edit').should route_to('raids#edit', id: '1')
    end

    it 'routes to #create' do
      post('/raids').should route_to('raids#create')
    end

    it 'routes to #update' do
      put('/raids/1').should route_to('raids#update', id: '1')
    end

    it 'routes to #destroy' do
      delete('/raids/1').should route_to('raids#destroy', id: '1')
    end

  end
end
