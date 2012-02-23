class ToHaml
  def initialize(path)
    @path = path
  end

  def convert_all!
    Dir["#{@path}/**/*.erb"].each do |file|
      puts "Converting #{file} to #{file.gsub(/\.erb$/, '.haml')}"
      `html2haml -rx #{file} #{file.gsub(/\.erb$/, '.haml')}`
    end
  end

  def git_convert_all!
    Dir["#{@path}/**/*.erb"].each do |file|
      haml_file = file.gsub(/\.erb$/, '.haml')
      put "Converting #{File.basename(file)} to #{File.basename(haml_file)}"
      `git mv #{file} #{haml_file}`
      `html2haml -rx #{haml_file} #{haml_file}`
      puts " - DONE"
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
    desc "Convert all erb files to haml"
    task :git do
      path = File.join(Rails.root, 'app', 'views')
      ToHaml.new(path).git_convert_all!
    end
  end
end