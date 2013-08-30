require 'spec_helper'

describe 'Drops' do
  describe 'GET /drops' do
    it 'responds with success' do
      get drops_path

      response.status.should be(200)
    end

    it 'uses the Drops data table' do
      DropsDatatable.should_receive(:new)

      get '/drops.json'
    end

    it 'displays the headings' do
      headings = ['Item Name', 'Character Name', 'Loot Type', 'Zone Name',
                  'Mob Name', 'Drop Time', 'Loot Method']

      get drops_path

      headings.each do |heading|
        response.body.should include heading
      end
    end
  end
end
