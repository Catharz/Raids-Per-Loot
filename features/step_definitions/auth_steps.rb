#CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "login" varchar(40), "name" varchar(100) DEFAULT '', "email" varchar(100), "crypted_password" varchar(40), "salt" varchar(40), "created_at" datetime, "updated_at" datetime, "remember_token" varchar(40), "remember_token_expires_at" datetime);
#INSERT INTO "users" VALUES(2,'guest','Guest User','guest@sample.com','976507e888e23613fc650cf230c4c78b6f05e9e5','94a65b3ae4824e99a310d93b31c541d361e8238f','2011-09-30 04:25:41.899386','2011-09-30 04:25:41.899386',NULL,NULL);

Given /^I am logged in as a user$/ do
  current_user = User.find_by_name('admin')
  unless current_user
    current_user = User.create!(:name => 'admin',
                                :email => 'admin@example.com',
                                :roles => ['admin'])
    current_user.save
  end
  user_service = current_user.services.first
  if user_service.nil?
    user_service = current_user.services.create(provider: 'developer',
                                                uid: current_user.email,
                                                uname: current_user.name,
                                                uemail: current_user.email)
    user_service.save
  end

  visit '/auth/developer'
  fill_in 'name', :with => current_user.name
  fill_in 'email', :with => current_user.email
  click_button 'Sign In'
  assert !User.find_by_name('admin').nil?
  assert :user_signed_in?
end
