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

require 'em-dir-watcher'
require File.join(File.dirname(__FILE__), './synlogger.rb')

class SynHub

	include SynLogger

	attr_accessor :git_bin
	attr_accessor :notes_repo
	attr_accessor :interval
	attr_accessor :commit_msg

	# Public: [describe method call]
	#
	# repo - [describe arguments]
	#
	# Returns [describe return type / data]
	def initialize(notes_repo=nil, env=nil)

		self.git_bin = '/usr/bin/git' # env
		self.notes_repo = notes_repo
		self.commit_msg = 'Note repo file update' # env
		self.interval = 60 # timer iterations

	end

	# public
	def add_watch

		notes_repo = self.notes_repo

		#self.interval = 4 if self.debug?

		#EM.set_effective_user "jeff"

		EM.run {

			repo = EMDirWatcher.watch notes_repo, :grace_period => 1.0, :exclude => ['.git'] do |paths|

				paths.each do |path|
					full_path = File.join(notes_repo, path)

					self.log("#{full_path}") if self.debug?

					timer = EM::PeriodicTimer.new(self.interval) do

						case File.exists? full_path

						when false
							puts("DEL: #{full_path}")
							p system("cd /home/jeff/notes.git; /usr/bin/git rm #{full_path}")

							result = system("cd /home/jeff/notes.git; /usr/bin/git commit -am grit-test")

							if result
								puts("update")
							else
								puts("ERR")
							end
							# ...
						when true
							puts("MOD: #{full_path}")
							p system("cd /home/jeff/notes.git; /usr/bin/git add #{full_path}")

							result = system("cd /home/jeff/notes.git; /usr/bin/git commit -a -m grit-test")

							if result
								puts("update")
							end
						else
							#sleep(5)
							puts("cancel")
						end
					end # end EM::timer loop
				end # end paths.each do
			end # end EM::dir.watch loop
		}
	end
end
