require 'spec_helper'

describe "instances/new.html.haml" do
  before(:each) do
    assign(:instance, stub_model(Instance).as_new_record)
  end

  it "renders new instance form" do
    render

    assert_select "form", :action => instances_path, :method => "post" do
    end
  end
end
