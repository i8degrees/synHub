#!/usr/bin/ruby
#
# 2012-02/01:jeff
#
#	~/Projects/notes_hub.git/sync.rb
#
# 	Watches the notes git repo for changes made to notes and upon said
# modification, automagically commits said change to the repo and pushes onwards
# to the "hub" repo.
#

require File.join(File.dirname(__FILE__), './lib/hub.rb')

notes = SynHub.new("/home/jeff/notes.git")
notes.setup_log('debug', 'file', '/tmp/debug.log', 'debug')

notes.datestamp_log("test")

notes.debug = true
notes.verbose = true

notes.add_watch
