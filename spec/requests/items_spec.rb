require 'spec_helper'

describe 'Items' do
  describe 'GET /items' do
    it 'responds with success' do
      get items_path

      response.status.should be(200)
    end

    it 'uses the Items data table' do
      ItemsDatatable.should_receive(:new)

      get '/items.json'
    end

    it 'displays the headings' do
      headings = ['Name', 'Loot Type', 'Slot(s)', 'Class(es)']

      get items_path

      headings.each do |heading|
        response.body.should include heading
      end
    end
  end
end
