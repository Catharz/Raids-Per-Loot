require "spec_helper"

describe ArchetypesController do
  describe "routing" do

    it "routes to #index" do
      get("/archetypes").should route_to("archetypes#index")
    end

    it "routes to #new" do
      get("/archetypes/new").should route_to("archetypes#new")
    end

    it "routes to #show" do
      get("/archetypes/1").should route_to("archetypes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/archetypes/1/edit").should route_to("archetypes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/archetypes").should route_to("archetypes#create")
    end

    it "routes to #update" do
      put("/archetypes/1").should route_to("archetypes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/archetypes/1").should route_to("archetypes#destroy", :id => "1")
    end

  end
end
