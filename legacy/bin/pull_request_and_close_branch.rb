#!/usr/bin/env ruby

# Usage:
# 
# When in a branch that you haven't pushed to origin, and you're changes are done, and you want a pull request
# and to delete your current branch, run this script.
#
# It will
#
# * Push your current branch to origin/[branch_name]
# * Checkout master
# * Delete your local branch that was just pushed
# * Open a new browser tab/window to the "make a pull request" form, with the proper branches selected.
#
# I use it as a git alias:
#
#  [alias]
#    close = !ruby ~/bin/pull_request_and_close_branch.rb

require 'rubygems'
require 'yaml'
require 'grit'
repo = Grit::Repo.new(".git")
if repo.head.nil?
  raise "No HEAD found for local branch of git repository.  Make sure you have HEAD setup properly!"
  exit 0
end
branch = repo.head.name.split.last.gsub(/[-. ]/, "_")

`git push -u origin #{branch} && git checkout master && git branch -d #{branch} && open "http://github.com/geezeoweb/geezeo/pull/new/#{branch}"`

case_id = branch.match(/^fb(\d+)-?/)
case_id = case_id[1] if case_id

if case_id

  puts "Resolving case #{case_id}"
  require 'foggy_bottom'


  config = YAML.load( File.read(File.expand_path File.join("~", ".fogbugz_creds")))
  api = FoggyBottom::Api.new("https://geezeohq.fogbugz.com", config['username'], config['password'])
  bug = api.find( case_id )

  if bug
    bug.resolve "Auto-resolving."
  else
    puts "Can't find bug."
  end
end

#, [2011-10-14T12:36:57.471902 #85175] DEBUG -- : Fetching endpoint
#D, [2011-10-14T12:36:58.285263 #85175] DEBUG -- : Fetching token
#D, [2011-10-14T12:36:58.285612 #85175] DEBUG -- : Attempting to access: https://geezeohq.fogbugz.com/api.asp?email=jmoses%40geezeo.com&password=R9uMT%25zTEz8%28Ku%29&cmd=logon&token=
#/Users/jmoses/.rvm/gems/ruby-1.9.2-p180@geezeo-pfm/gems/foggy_bottom-0.0.3/lib/foggy_bottom/api.rb:37:in `fetch_token': undefined method `content' for nil:NilClass (NoMethodError)
#	from /Users/jmoses/.rvm/gems/ruby-1.9.2-p180@geezeo-pfm/gems/foggy_bottom-0.0.3/lib/foggy_bottom/api.rb:16:in `initialize'
#	from /Users/jmoses/bin/pull_request_and_close_branch.rb:41:in `new'
#	from /Users/jmoses/bin/pull_request_and_close_branch.rb:41:in `<main>'

