require 'spec_helper'

describe 'viewer/show.html.erb' do
  it 'renders the page contents' do
    view.should_receive(:user_signed_in?).and_return(false)
    assign(:page, stub_model(Page,
                             :name => 'home',
                             :title => 'Home',
                             :navlabel => 'Home',
                             :body => 'Hello World!'))

    render

    rendered.should match(/Hello World!/)
  end
end
