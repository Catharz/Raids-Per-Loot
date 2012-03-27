#CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "login" varchar(40), "name" varchar(100) DEFAULT '', "email" varchar(100), "crypted_password" varchar(40), "salt" varchar(40), "created_at" datetime, "updated_at" datetime, "remember_token" varchar(40), "remember_token_expires_at" datetime);
#INSERT INTO "users" VALUES(2,'guest','Guest User','guest@sample.com','976507e888e23613fc650cf230c4c78b6f05e9e5','94a65b3ae4824e99a310d93b31c541d361e8238f','2011-09-30 04:25:41.899386','2011-09-30 04:25:41.899386',NULL,NULL);

Given /^I am logged in as a user$/ do
  current_user = User.find_by_login('guest')
  unless current_user
    current_user = User.create!(:name => 'Guest User',
                                :login => 'guest',
                                :email => 'guest@sample.com',
                                :password => 'changeme',
                                :password_confirmation => 'changeme',
                                :crypted_password => '976507e888e23613fc650cf230c4c78b6f05e9e5',
                                :salt => '94a65b3ae4824e99a310d93b31c541d361e8238f',
                                :created_at => '2011-09-30 04:25:41.899386')
    current_user.save
  end

  visit '/login'
  fill_in "login", :with => current_user.login
  fill_in "password", :with => current_user.password
  click_button "Log in"
  assert !User.find_by_login("guest").nil?
  assert :logged_in?
end