#!/usr/bin/ruby
#
# 2012-02/01:jeff
#
#	~/Projects/scratch/notes-sync.rb
#
# 	Watches the notes git repo for changes made to notes and upon said
# modification, automagically commits said change to the repo and pushes onwards
# to the "hub" repo.
#
#			REFERENCES
#
# 1. 	https://github.com/mockko/em-dir-watcher
#
#
#			TODO
#	1.	http://daemons.rubyforge.org/
#	2.

#require 'eventmachine'
#require 'rb-inotify'
require 'em-dir-watcher'
require 'grit'

class SynHub

	#include Handler

	attr_writer 	:debug, :verbose
	attr_accessor 	:notes_repo

	# public
	def initialize(notes_repo=nil, env=nil) # TODO: ENV hash

		self.notes_repo = notes_repo

		#@env = { :NOTES_REPO => notes_repo, :SHELL => "/bin/sh", :PWD => "/home/jeff/notes.git",
		#		 :PATH => "/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/bin:/sbin"
		#	   }

		# p @env if self.debug?

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

		#git_dir = File.join(self.notes_repo, '/.git')
		#git = Grit::Git.new(git_dir)
		#git.native(:commit, { :env => ENV['chdir'] = '/home/jeff/notes', :base => true, :raise => true, :timeout => 60, }, "-a -m grit-test")

		#path_exec = "cd #{@env['NOTES_REPO']}"
		#commit_exec = "git commit -a -m" << " #{commit_msg}"
		#result = system("#{path_exec} && #{commit_exec}")
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

		git_dir = File.join(self.notes_repo, '/.git')
		git = Grit::Git.new(git_dir)

		git.native(:push, { :base => true, :raise => true, :timeout => 60, }, "master")

		#update_exec = "git push"
		#path_exec = "cd #{@env['NOTES_REPO']}"
		#result = system("#{path_exec} && #{update_exec}")
		#p result if self.debug?

		#if result != 0
		#	return false # exit code 1 -- failure state
		#end

		#return true # exit code 0 -- success state
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

		#git_dir = File.join(self.notes_repo, '/.git')
		#git = Grit::Git.new(git_dir)
		#result = git.native(:status, { :base => true, :raise => true, :timeout => 60, }, "master")

		#status_exec = "git status"
		#path_exec = "cd #{@env['NOTES_REPO']}"
		#result = system("#{path_exec} && #{status_exec}")
		result = system("cd /home/jeff/notes.git; /usr/bin/git status")
		p result if self.debug?

		#return true # temp

		if result != true
			return false # exit code 1 -- failure state
		end

		return true # exit code 0 -- success state
	end

	def verbose?
		return @verbose
	end

	def debug?
		return @debug
	end

=begin
	# private
	def repo_add_timer(interval=60)

		@interval = interval
		#@loop = loop

		timer = EM::PeriodicTimer.new(interval) do
			# git status
			# git commit
			# git push
		end
	end
=end

	# ~private
	def add_watch
		notes_repo = self.notes_repo

		timeout = 4
		n = 0
		t = 0

		#EM.set_effective_user "jeff"

		#if notes_repo != nil
		#		p notes_repo
		#	else
		#		puts "notes_repo is nil"
		#	end

		#EM.run {

			repo = EMDirWatcher.watch notes_repo, :grace_period => 1.0, :exclude => ['.git'] do |paths|
				#p notes_repo
				paths.each do |path|
					full_path = File.join(notes_repo, path)
					p full_path
					if File.exists? full_path
							#timer = EM::PeriodicTimer.new(timeout) do
							#if SynNotes::verbose? or SynNotes::debug?
								puts("MOD: #{path}")
								#puts("DEL: #{path}")
								#SynNotes::log("MOD: #{path}")
								#SynNotes::log("DEL: #{path}")
								t+=1
							puts("main iterations: #{t}") if self.debug?
							#end

							if self.commit
							#if self.status
								#self.update

								n+=1
								puts("timer iterations: #{n}") if self.debug?
								#SynNotes::log("#{timeout}'n' tick: #{n}") if SynNotes::debug?
							else
								#timer.cancel
								sleep(5)
								puts "sleeping"
								#SynNotes::log("ERR: Ptimer(#{timeout}) canceled") if SynNotes::debug?
							end # end self.status if
						#end # end timer do
					else
						puts("DEL: #{path}")
					end # end File.exists if
				end # end paths do
			end # end repo EM.watch do
			#puts "tock"
			#t+=1
			#puts("main iteration: #{t}") if self.debug?
			#SynNotes::log("'t' tick: #{t}") if SynNotes::debug?
		#}
	end
end

EM.run {
repo = SynHub.new("/home/jeff/notes.git")
repo.add_watch
}
