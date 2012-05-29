require 'spec_helper'

describe "instances/edit.html.haml" do
  before(:each) do
    @instance = assign(:instance, stub_model(Instance))
  end

  it "renders the edit instance form" do
    render

    assert_select "form", :action => instances_path(@instance), :method => "post" do
    end
  end
end
