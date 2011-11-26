class AddDefaultUsers < ActiveRecord::Migration
  def self.up
    if !User.find_by_login('admin')
      User.create(:login => 'admin', :name => 'Admin User', :email => 'admin@sample.com',
                :password => 'changeme', :password_confirmation => 'changeme')
    end
    if !User.find_by_login('guest')
      User.create(:login => 'guest', :name => 'Guest User', :email => 'guest@sample.com',
                :password => 'changeme', :password_confirmation => 'changeme')
    end
  end

  def self.down
  end
end
