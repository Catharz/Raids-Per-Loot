require 'spec_helper'

describe 'Drops' do
  describe 'GET /drops' do
    it 'responds with success' do
      get drops_path

      response.status.should be(200)
    end

    it 'passes the params to the Drops Query object' do
      params = {'sEcho' => '1', 'action' =>'index', 'controller' => 'drops', 'format' => 'json'}
      drops_query = double(DropsQuery)
      drops_query.stub(:drops).and_return([])
      DropsQuery.should_receive(:new).with(params).and_return(drops_query)

      get '/drops.json?sEcho=1'
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
