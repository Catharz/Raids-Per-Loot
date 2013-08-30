require 'spec_helper'

describe LinkCategoriesController do
  describe 'routing' do

    it 'routes to #index' do
      get('/link_categories').should route_to('link_categories#index')
    end

    it 'routes to #new' do
      get('/link_categories/new').should route_to('link_categories#new')
    end

    it 'routes to #show' do
      get('/link_categories/1').should route_to('link_categories#show',
                                                id: '1')
    end

    it 'routes to #edit' do
      get('/link_categories/1/edit').should route_to('link_categories#edit',
                                                     id: '1')
    end

    it 'routes to #create' do
      post('/link_categories').should route_to('link_categories#create')
    end

    it 'routes to #update' do
      put('/link_categories/1').should route_to('link_categories#update',
                                                id: '1')
    end

    it 'routes to #destroy' do
      delete('/link_categories/1').should route_to('link_categories#destroy',
                                                   id: '1')
    end

  end
end
