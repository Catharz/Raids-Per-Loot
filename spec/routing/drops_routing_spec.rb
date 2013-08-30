require 'spec_helper'

describe DropsController do
  describe 'routing' do

    it 'routes to #index' do
      get('/drops').should route_to('drops#index')
    end

    it 'routes to #new' do
      get('/drops/new').should route_to('drops#new')
    end

    it 'routes to #show' do
      get('/drops/1').should route_to('drops#show', id: '1')
    end

    it 'routes to #edit' do
      get('/drops/1/edit').should route_to('drops#edit', id: '1')
    end

    it 'routes to #create' do
      post('/drops').should route_to('drops#create')
    end

    it 'routes to #update' do
      put('/drops/1').should route_to('drops#update', id: '1')
    end

    it 'routes to #destroy' do
      delete('/drops/1').should route_to('drops#destroy', id: '1')
    end

  end
end
