#! /bin/env ruby
#
#########################################################################################
# Author: Alice "Duchess" Archer
# Copyright (c) 2015 Isaac Archer under the MIT License
# Project Name: Husk
# Project Description:
# Husk is a configurable irc bot using rirc framework
# it is configured via a ruby script file that sets variables for the irc bot
# it is plugable using the plugin design and manager in rirc
# it can reload core commands to control the bot during runtime, and not just plugins
#########################################################################################

load 'rirc.rb'
load 'config.rb'

# create the bot
print "creating bot... "
STDOUT.flush
bot = IRCBot.new(Config_var.network, Config_var.port, Config_var.nick, Config_var.username, Config_var.realname)
puts "done"

# create the plugin manager and tell it where to look for plugins
print "creating plugin manager... "
STDOUT.flush
plug = Plugin_manager.new(Config_var.plugin_dir)
puts "done"

# initial connect
bot.connect
puts "Connected to"
puts "	↪ network = #{bot.network}"
puts "	↪ port = #{bot.port}"

if Config_var.use_ssl
      bot.connect_ssl
      puts "Connecting Using a Secure Connection"
end

if Config_var.use_pass
      bot.connect_pass(Config_var.pass)
      puts "Connecting Using a password, #{pass}"
end

to_ignore = []

if Config_var.ignore_list.length != 0
      puts "Creating Ignore List"
      Config_var.ignore_list.each do |a|
            to_ignore.push(a)
            puts "	↪ #{a}"
      end
end

# send connect info
# nickserv_pass can be empty
bot.auth(Config_var.nickserv_pass)
puts "Authenticated with"
puts "	↪ nick = #{bot.nick_name}"
puts "	↪ username = #{bot.user_name}"
puts "	↪ realname = #{bot.real_name}"
puts "	↪ identifying with #{nickserv_pass}"

# joining channels
puts "Joining"
Config_var.channels.each { |a| bot.join(a); puts "	↪ #{a}"; }

# setting admins
puts "Adding admins"
Config_var.admins.each { |a| bot.add_admin(a); puts "	↪ #{a}"; }

# loading plugins
puts "Loading plugins"
Config_var.plugins_list.each do |a|
	print "	↪ loading #{a}... "
	STDOUT.flush
	puts plug.plugin_load(a)
end

puts "Creating Backlog"
backlog = []

load 'commands.rb'
puts "Loaded Core"

# the main loop for the socket
puts "Starting #{bot.nick_name}"

until bot.socket.eof? do
	ircmsg = bot.read
	msg = bot.parse(ircmsg)

	if ircmsg == "PING" or bot.nick_name == msg.nick or to_ignore.include? msg.nick
		next
	else
            if msg.message_regex(/^`core refresh$/) and msg.nick == Config_var.dev_admin
                  load 'commands.rb'
                  bot.notice(msg.nick, "Core Reloaded")
                  next
            end

            if commands(msg) then next end

            responses = plug.check_all(msg, bot.admins, backlog)

		responses.each { |a| if a != "" then bot.say(a) end }
      end
end
