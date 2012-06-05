# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'spork',
      :cucumber_env => {'RAILS_ENV' => 'test'},
      :rspec_env => {'RAILS_ENV' => 'test'},
      :test_unit => false, :wait => 240 do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch('config/routes.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('spec/spec_helper.rb')
  watch(%r{^spec/support/.+\.rb$})
end

guard 'bundler' do
  watch('Gemfile')
end

guard :livereload do
  watch(%r{^app/.+\.(erb|haml)})
  watch(%r{^app/helpers/.+\.rb})
  watch(%r{^public/.+\.(css|js|html)})
  watch(%r{^config/locales/.+\.yml})
end

guard 'test', :colour => true, :drb => false do
  watch(%r{app/(.+)/(.+)\.rb}) { |m| "test/#{m[1]}/#{m[2]}_test.rb" }
  watch(%r{test/(.+)/(.+)_test\.rb})
  watch(%r{test/test_helper.rb}) { "test" }
  watch(%r{spec/factories/.+\.rb$}) { "test" } # used by unit and rspec tests
end

group :backend do
  guard 'rspec', :version => 2, :cli => '--drb', all_on_start: false do
    watch(%r{^spec/.+_spec\.rb})
    watch(%r{^lib/(.+)\.rb}) { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb') { "spec" }
    watch(%r{spec/factories/.+\.rb$}) { "spec" } # used by unit and rspec tests

    # Rails example
    watch('spec/spec_helper.rb') { "spec" }
    watch('config/routes.rb') { "spec/routing" }
    watch('app/controllers/application_controller.rb') { "spec/controllers" }
    watch(%r{^spec/.+_spec\.rb})
    watch(%r{^app/(.+)\.rb}) { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb}) { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb}) { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
    watch(%r{^app/views/(.+)/}) { |m| "spec/requests/#{m[1]}_spec.rb" }
  end
end

group :frontend do
  guard 'haml' do
    watch %r{^src/.+(\.html\.haml)}
  end

  guard 'cucumber', :cli => '--drb --format progress --no-profile', all_on_start: false do
    watch(%r{^features/.+\.feature$})
    watch(%r{^features/support/.+$}) { 'features' }
    watch(%r{^features/step_definitions/.+$}) { 'features' }
    watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/manage_#{m[1]}s.feature")][0] || 'features' }
    watch(%r{^features/step_definitions/drop_steps\.rb$}) { |m| Dir[File.join("**/assign_#{m[1]}.feature")][0] || 'features' }
  end
end
