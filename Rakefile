desc "Link all the files"
task :link_all do
  linkable_files.each do |file|
    source = linkable_path(file)
    target = linkable_to_target(file)

    if ENV['FORCE'] && File.exists?(target) && ! File.symlink?(target)
      puts "Removing existing target #{file}"
      File.unlink(target)
    end

    if File.symlink?(target)
      puts "Skipping #{file}, already a symlink"
    elsif File.exists?(target)
      puts "Skipping #{file}, target exists"
    else
      File.symlink(source, target)
    end
  end
end

desc "Clean existing links"
task :clean do
  linkable_files.each do |file|
    target = linkable_to_target(file)

    if File.symlink?(target)
      File.unlink(target)
    end
  end
end

desc "Verify if files ar linked"
task :verify do
  linkable_files.each do |file|
    puts "#{file} #{File.symlink?(linkable_to_target file) ? 'is' : 'is not'} a symlink"
  end
end

def linkable_to_target(file)
  File.expand_path("~/.#{file}")
end

def linkable_path(file)
  File.expand_path( File.join(File.dirname(__FILE__), file))
end

def linkable_files
  Dir['*'].reject {|f| f == 'Rakefile' }
end
