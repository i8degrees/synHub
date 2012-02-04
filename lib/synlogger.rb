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

	attr_accessor :logger
	attr_accessor :log_level

	def debug=(value)
		@debug = value
	end

	def debug?
		return @debug
	end

	def verbose=(value)
		@verbose = value
	end

	def verbose?
		return @verbose
	end

	# Public: Initializes a Log4r::Logger instance for input/output logging.
	#
	# logger_name	-	Name of the logger instance object
	# 					(Default: String 'debug')
	#
	# outputter		-	Output redirection: < stdin | stderr | stdout | file >
	#					(Default: String 'stderr')
	#
	# logfile 		-	File accessible path of the log file
	#					(Default: nil)
	#
	# log_level		-	can be one of: < debug | error | fatal | info | warn>
	#					(Default: String 'debug')
	#
	# Returns the instance of the Logger object
	#
	def setup_log(logger_name='debug', outputter='stderr', logfile=nil, log_level='debug')

		self.logger = Log4r::Logger.new(logger_name)
		self.log_level = log_level

			case outputter.downcase!
				when "stdin"
					self.logger.outputters << Log4r::Outputter.stdin

				when "stderr"
					self.logger.outputters << Log4r::Outputter.stderr

				when "stdout"
					self.logger.outputters << Log4r::Outputter.stdout

				when "file"
					if File.exists? logfile
						self.logger.outputters << Log4r::FileOutputter.new(logger_name, :filename => logfile)
					end
				else
					self.logger.outputters << Log4r::Outputter.stderr
				end

		self.logger.debug("Log file initialized")

		return self.logger

	end # setup_log

	def log(msg=nil)

		self.log_level = log_level

		if msg != nil
			case log_level
				when 'diag', 'debug'
					self.logger.debug(msg)
				when 'err', 'error'
					self.logger.error(msg)
				when 'crit', 'fatal'
					self.logger.fatal(msg)
				when 'info'
					self.logger.info(msg)
				when 'warn'
					self.logger.warn(msg)
				end
		else
			return false
		end
	end # log

	# Returns false on failure
	# Returns an appended datestamp on the log message upon success
	#
	def datestamp_log(msg=nil)

		t = Time.now

		if msg != nil
			self.log("#{t} - #{msg}")
		else
			return false
		end
	end # datestamp_log

	# Returns false on failure
	# Returns an inspected variable
	#
	def var_dump(var)

		if var != nil
			self.log ("Stub message. DO ME")
			#self.logger << Log4r::ObjectFormatter.format_object(var)
		else
			return false
		end
	end # var_dump

end
