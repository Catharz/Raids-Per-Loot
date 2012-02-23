class ToHaml
  def initialize(path)
    @path = path
  end

  def convert_all!
    Dir["#{@path}/**/*.erb"].each do |file|
      haml_file = file.gsub(/\.erb$/, '.haml')
      puts "Converting #{File.basename(file)} to #{File.basename(haml_file)}"
      `html2haml -rx #{file} #{haml_file}`
    end
  end

  # html2haml will create an empty file before parsing
  # so can't just 'git mv' and then convert.
  # need to convert a 'backup' of the file.
  def git_convert_all!
    Dir["#{@path}/**/*.erb"].each do |file|
      haml_file = file.gsub(/\.erb$/, '.haml')
      temp_file = file.gsub(/\.erb$/, '.tmp')
      begin
        puts "Copying #{file} to #{temp_file}"
        File.copy_stream file, temp_file
        puts "Renaming #{file} to #{haml_file}"
        `git mv #{file} #{haml_file}`
        puts "Converting #{File.basename(file)} to #{File.basename(haml_file)}"
        `html2haml -rx #{temp_file} #{haml_file}`
        puts "Removing #{temp_file}"
        File.delete temp_file
      rescue
        File.rename(temp_file, file)
        File.delete(temp_file)
      end
    end
  end
end

namespace :haml do
  namespace :convert do
    desc "Convert all erb files to haml"
    task :local do
      path = File.join(Rails.root, 'app', 'views')
      ToHaml.new(path).convert_all!
    end
  end
  namespace :convert do
    desc "Rename erb files to haml via git and convert"
    task :git do
      path = File.join(Rails.root, 'app', 'views')
      ToHaml.new(path).git_convert_all!
    end
  end
end