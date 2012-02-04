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

class SynHub

	attr_writer 	:debug, :verbose
	attr_accessor 	:notes_repo

	# public
	def initialize(notes_repo=nil, env=nil)

		self.notes_repo = notes_repo
		# git_dir
		# repo_dir / work_tree
		# git_bin
		# commit_msg / commit_template
		# @env / ENV[]
		# shell
		#

		# init/prep EM instance -- watch & timer
		# exec said instance
		# fork a daemon
		# profit $$$
		#

		p self.notes_repo

		self.debug = true
		self.verbose = true
	end

	# Performs a git commit to the repo
	#
	# 	method		commit
	#
	# Returns true on success; false on failure
	#
	# ~public
	def commit(msg=nil) # TODO: template_file AKA .git/COMMIT_EDITMSG or such

		if msg != nil
			commit_msg = msg
		else # defaults
			commit_msg = "Note repo file update"
		end

		result = system("cd /home/jeff/notes.git; /usr/bin/git add .; /usr/bin/git commit -am grit-test")
		p result if self.debug?

		if result != true
			return false # exit code 1 -- failure state
		end

		return true # exit code 0 -- success state
	end

	# Performs a git push onwards (to the Neural Net)
	#
	# 	method		update
	#
	# Returns true on success; false on failure
	#
	# ~public
	def update

		if result != 0
			return false # exit code 1 -- failure state
		end

		return true # exit code 0 -- success state
	end

	# Check the exit return status from the git repo in order to determine
	# if it is sane to progress onwards (...sync to the neural net hub)
	#
	# 	method		status
	#
	# Returns true on success; false on failure
	#
	# result = system("git add . && git commit -am FUCKYOUNIGGERBUTTFUCKER && git push")
	def status

		result = system("cd /home/jeff/notes.git; /usr/bin/git status")
		p result if self.debug?

		if result != true
			return false # exit code 1 -- failure state
		end

		return true # exit code 0 -- success state
	end

	def verbose?
		return self.verbose
	end

	def debug?
		return self.debug
	end

	# private
	def add_watch_timer(interval=60)

		#interval = interval # timer iterations
		#loop = loop # main loop iterations

		timer = EM::PeriodicTimer.new(interval) do
			# git status
			# git commit
			# git push
		end
	end
=end

	# private
	def add_watch
		notes_repo = self.notes_repo

		timeout = 4
		n = 0
		t = 0

		#EM.set_effective_user "jeff"

		EM.run {

			repo = EMDirWatcher.watch notes_repo, :grace_period => 1.0, :exclude => ['.git'] do |paths|
				#p notes_repo
				paths.each do |path|
					full_path = File.join(notes_repo, path)
					p full_path
					if File.exists? full_path
							#timer = EM::PeriodicTimer.new(timeout) do
								puts("MOD: #{path}")
								t+=1
							puts("main iterations: #{t}") if self.debug?

							if self.commit
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

repo = SynHub.new("/home/jeff/notes.git")
repo.add_watch
