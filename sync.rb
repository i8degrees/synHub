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

repo = SynHub.new("/home/jeff/notes.git")
repo.setup_log
#repo.log("test")

repo.debug = true
repo.verbose = true

repo.add_watch
