#!/usr/bin/env ruby

require 'rubygems'
require 'everyx'
require 'nserver'

class Task
  def call
    NServer::Client.try_notify("Test\nMessage.")
  end
end

ex = Everyx::Everyx.new
ex.in(10, Task.new)

ex.join
