# @author Craig Read
#
# Controller for the Version history view.
#
# only a js formatting option is provided, as the
# history is displayed in a jQuery popup
class VersionsController < ApplicationController
  authorize_resource

  def index
    @versions = Version.includes(:item).order('created_at desc')

    respond_to do |format|
      format.js # index.js.coffee
    end
  end
end