class VersionsController < ApplicationController
  authorize_resource

  def index
    @versions = Version.includes(:item).order('created_at desc')

    respond_to do |format|
      format.js # index.js.coffee
    end
  end
end