#!/usr/bin/ruby
#
# 2012-02/03:jeff
#
#	~/Projects/notes_hub.git/lib/synlogger.rb
#
# 	Watches the notes git repo for changes made to notes and upon said
# modification, automagically commits said change to the repo and pushes onwards
# to the "hub" repo.
#

require 'log4r'

module SynLogger

	#include Log4r

	def verbose=(value)
		@verbose = value
	end

	def verbose?
		return @verbose
	end

	def debug=(value)
		@debug = value
	end

	def debug?
		return @debug
	end

	def setup_log(log_name=nil, log_path=nil, log_level=nil)

		@logger = Log4r::Logger.new('debug')

		#@logger.outputters << Log4r::Outputter.stderr
		@logger.outputters << Log4r::FileOutputter.new('debug', :filename => '/tmp/debug.log')

		@logger.debug("Log file initialized")

		return @logger
	end

	def log(msg=nil)
		@logger.debug(msg)
	end
end

=begin
# Initializes a Logger instance and outputs, at the selected log level, to
	# either: a) the standard STDERR console; b) user-defined log output file set
	# at "settings.log_file"
	#
	# Usage: log(msg, log_level)
	#	...where the optional log_level is one of:
	#
	#			debug, error, fatal, info, warn
	#
	#	...said level defaults to "info".
	#
	def log(msg="", log_level="info")

		logger = Log4r::Logger.new('debug')

		if File.exists?(settings.log_file) != true
			logger.outputters << Log4r::Outputter.stderr
			#halt 500, "CRIT.err: Logger failed to initiate #{settings.log_file}"
		else # alright, here we go!
			logger.outputters << Log4r::FileOutputter.new('debug', :filename => settings.log_file)
		end

		logger.info('Logger instance initialized')

			case log_level
				when 'debug', 'diag'
					logger.debug(msg)
				when 'error', 'err'
					logger.error(msg)
				when 'fatal', 'crit'
					logger.fatal(msg)
				when 'info'
					logger.info(msg)
				when 'warn'
					logger.warn(msg)
			else
				logger.debug(msg)
			end

		# we should never reach this point
		return true

	end
=end
