#!/bin/env ruby
#############################################################################################
# author: apels <Alice Duchess>
#############################################################################################

# note: example code does not actually run
# a running example should be posted soon

load 'rirc.rb'

class Sys_status < Pluginf

	# any functions you may need can be included here
      def status
            #hostname
            host = `hostname`.to_s.chomp!
            #uptime
            uptime = `uptime -p`.to_s.chomp![3..-1]
            #processes
            processes = `ps -ef | wc -l`.to_s.chomp!
            #memory
            percent_mem = `free | awk 'FNR == 3 {print $3/($3+$4)*100}'`.to_s.chomp!
            tokens = `free -m | grep -i "Mem:"`.split(' ')
            total_mem = tokens[1]
            used_mem = tokens[2]
            #load
            cpu_use = `mpstat | awk '$3 ~ /CPU/ { for(i=1;i<=NF;i++) { if ($i ~ /%idle/) field=i } } $3 ~ /all/ { print 100 - $field }'`.to_s.chomp!

            #Server Aika up 18d 01h 32m 43s, 675 TCP connections, 146 processes, 17.1GB/64GB RAM in use.
            return "Server \x0303#{host}\x03 up \x0303#{uptime}\x03, \x0303#{processes}\x03 Processes, \x0303#{percent_mem}\x03% of \x0303#{total_mem}\x03 MB of Memory Used, CPU utilization: \x0303#{cpu_use}\x03%"
      end

	def script(message, admins, backlog)

		# plugins must return the raw mesaage they wish to have sent to the socket
		# return "PRIVMSG #{message.chan} :hello"
		# or you can use functions to simplify this
		# some are provided below
            @res = status
		return privmsg(message.channel, @res)
	end

	def privmsg(dest, message)
		return "PRIVMSG #{dest} :#{message}"
	end

	def action(dest, message)
		return "PRIVMSG #{dest} :\01ACTION\07\01 #{message}"
	end

	def notice(dest, message)
		return "NOTICE #{dest} :#{message}"
	end
end

# allows you to support multiple regexes
# prefix = [
#		//,
#		//
#	   ]
#
# reg_p = Regexp.union(prefix)

# information the plugin needs to be initialized with
reg = /^`stats$/ # regex to call the plugin
filename = "stats.rb" # file name
pluginname = "stats" # name for plugin
description = "`status gives host status" # description and or help

# plugin = Class_name.new(regex, name, file_name, help)
# this temporary global is used for handing the new plugin back to the bot
$temp_plugin = Sys_status.new(reg, pluginname, filename, description)
