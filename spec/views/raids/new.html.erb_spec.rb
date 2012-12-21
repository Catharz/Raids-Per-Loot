require 'spec_helper'

describe "raids/new.html.erb" do
  before(:each) do
    assign(:raid, stub_model(Raid).as_new_record)
  end

  it "renders new raid form" do
    render

    assert_select "form", :action => raids_path, :method => "post" do
    end
  end
end
