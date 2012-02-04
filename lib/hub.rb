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
require File.join(File.dirname(__FILE__), './git.rb')

class SynHub
	include SynLogger

	# git_dir
	# repo_dir / work_tree
	# git_bin
	# commit_msg / commit_template
	# @env / ENV[]
	# shell
	#

	# Public: [describe method call]
	#
	# repo - [describe arguments]
	#
	# Returns [describe return type / data]
	def initialize(notes_repo=nil, env=nil)

		#self.notes_repo = notes_repo

		self.debug = false
		self.verbose = false

		# init/prep EM instance -- watch & timer
		# exec said instance
		# fork a daemon
		# profit $$$
		#

		#self.log(notes_repo)
	end

	# private
	def add_watch
		notes_repo = '/home/jeff/notes.git'
		#notes_repo = self.notes_repo

		timeout = 4
		n = 0
		t = 0

		#EM.set_effective_user "jeff"

		EM.run {

			repo = EMDirWatcher.watch notes_repo, :grace_period => 1.0, :exclude => ['.git'] do |paths|

				paths.each do |path|
					full_path = File.join(notes_repo, path)
					self.log("hi") if self.debug?
					if File.exists? full_path
							#timer = EM::PeriodicTimer.new(timeout) do
								puts("MOD: #{path}")
								t+=1
							puts("main iterations: #{t}") if self.debug?

							if self.env?
							#if self.commit
								#self.update

								n+=1
								puts("timer iterations: #{n}") if self.debug?
							else
								#timer.cancel
								sleep(5)
								puts "sleeping"
							end # end self.status if
						#end # end timer do
					else
						puts("DEL: #{path}")
					end # end File.exists if
				end # end paths do
			end # end repo EM.watch do
		}
	end
end
