require "spec_helper"

describe RaidTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/raid_types").should route_to("raid_types#index")
    end

    it "routes to #new" do
      get("/raid_types/new").should route_to("raid_types#new")
    end

    it "routes to #show" do
      get("/raid_types/1").should route_to("raid_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/raid_types/1/edit").should route_to("raid_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/raid_types").should route_to("raid_types#create")
    end

    it "routes to #update" do
      put("/raid_types/1").should route_to("raid_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/raid_types/1").should route_to("raid_types#destroy", :id => "1")
    end

  end
end
