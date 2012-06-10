module RemoteConnectionHelper
  def internet_connection?
    # Only check if it's nil
    if @connected.nil?
      @connected = connected?
    else
      @connected
    end
  end

  private
  def connected?
    begin
      # Always return false if we're testing'
      if ENV["RAILS_ENV"].eql? "test"
        false
      else
        true if open("http://www.google.com/")
      end
    rescue
      false
    end
  end
end