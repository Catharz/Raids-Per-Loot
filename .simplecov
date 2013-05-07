SimpleCov.at_exit do
  SimpleCov.result.format!
  `open #{Dir.pwd}/coverage/index.html`
end

# Commented out as this doesn't seem to work 100% the way I'd like
#
#if %w{yes true on}.include? ENV['COVERAGE']
#  puts 'Running tests with coverage'
#
#  SimpleCov.start do
#    add_filter 'spec'
#    add_filter 'features'
#    add_filter 'test'
#
#    add_group 'Observers', 'app/observers'
#    add_group 'DataTables', 'app/datatables'
#    add_group 'Changed' do |source_file|
#      `git status --untracked=all --porcelain`.split("\n").detect do |status_and_filename|
#        _, filename = status_and_filename.split(' ', 2)
#        source_file.filename.ends_with?(filename)
#      end
#    end
#  end
#end