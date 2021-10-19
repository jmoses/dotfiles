#!/usr/bin/env ruby

require 'rubygems'
require 'grit'

repo = Grit::Repo.new( Dir.pwd )
if repo.head.nil?
  raise "No HEAD found for local branch of git repository.  Make sure you have HEAD setup properly!"
  exit 0
end
current_branch = repo.head.name.split.last

%x{ git pull && git push && git checkout master && git merge #{current_branch} && git pull && git push }

