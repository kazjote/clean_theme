#!/usr/bin/env ruby

# Simple script which can be used with couchapp to automatically
# push applications to couchdb on files update on systems supporting inotify.
#
# First install rubygems in your system, then:
#
# $ sudo gem install rb-inotify
# $ cd couchapp_project
# $ ./couchapp_updater
#

require 'rubygems'
require 'rb-inotify'
require 'logger'

log = Logger.new(STDOUT)
log.level = Logger::DEBUG

class Compiler
  def initialize(log)
    @notifier = INotify::Notifier.new

    @notifier.watch("application.sass", :modify) do |event|
      log.info("Compiling SASS")
      `sass application.sass > application.css`
    end
  end

  def process
    @notifier.process
  end
end

while true
  Compiler.new(log).process
  log.info("Waiting for more events")
end
