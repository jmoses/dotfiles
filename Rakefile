desc "Link all the files"
task :link_all do
  Dir['*'].reject {|f| f == 'Rakefile' }.each do |file|
    `ln -s #{f} ~/#{File.basename f}`
  end
end
