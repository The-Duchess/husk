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
bot = IRCBot.new(network, port, nick, username, realname)
puts "done"

# create the plugin manager and tell it where to look for plugins
print "creating plugin manager... "
STDOUT.flush
plug = Plugin_manager.new(plugin_dir)
puts "done"

# initial connect
bot.connect
puts "Connected to"
puts "	↪ network = #{bot.network}"
puts "	↪ port = #{bot.port}"

if use_ssl
      bot.connect_ssl
      puts "Connecting Using a Secure Connection"
end

if use_pass
      bot.connect_pass(pass)
      puts "Connecting Using a password, #{pass}"
end

# send connect info
# nickserv_pass can be empty
bot.auth(nickserv_pass)
puts "Authenticated with"
puts "	↪ nick = #{bot.nick_name}"
puts "	↪ username = #{bot.user_name}"
puts "	↪ realname = #{bot.real_name}"
puts "	↪ identifying with #{nickserv_pass}"

# joining channels
puts "Joining"
channels.each { |a| bot.join(a); puts "	↪ #{a}"; }

# setting admins
puts "Adding admins"
admins.each { |a| bot.add_admin(a); puts "	↪ #{a}"; }

# loading plugins
puts "Loading plugins"
plugins_list.each do |a|
	print "	↪ loading #{a}... "
	STDOUT.flush
	puts plug.plugin_load(a)
end

load 'commands.rb'

puts "starting bot"

until bot.socket.eof? do
	ircmsg = bot.read
	msg = bot.parse(ircmsg)

	if ircmsg == "PING" or bot.nick_name == msg.nick
		next
	else
            if msg.message_regex(/^`core refresh$/) and msg.nick == dev_admin
                  load 'commands.rb'
            end

            responses = plug.check_all(msg, admins, backlog)

		responses.each { |a| if a != "" then bot.say(a) end }
      end
end
