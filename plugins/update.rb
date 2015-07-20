#!/bin/env ruby
#############################################################################################
# author: apels <Alice Duchess>
#############################################################################################

load 'rirc.rb'

class Git_pull < Pluginf

	def script(message, admins, backlog)

		if !admins.include? message.nick then return notice(message.nick, "You are not in the admin list, please contact an admin for help.") end

		`git pull`
		return notice(message.nick, "pull completed")
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


reg = /^`pull$/ # regex to call the plugin
filename = "update.rb" # file name
pluginname = "git" # name for plugin
description = "`pull allows an admin to pull the most recent version of the bot" # description and or help

$temp_plugin = Git_pull.new(reg, pluginname, filename, description)
