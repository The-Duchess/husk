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
#########################################################################################

require_relative 'rirc.rb'
load 'commands.rb'
require_relative 'config.rb'

class Config_obj
      include Config_var
end

def main

      configs = Config_obj.new

      # create the bot
      print "Creating Bot... "
      STDOUT.flush
      bot = IRCBot.new(configs.network, configs.port, configs.nick, configs.username, configs.realname)
      puts "done"

      print "Creating the Core... "
      STDOUT.flush
      cmds = Command_obj.new
      puts "done"

      # create the plugin manager and tell it where to look for plugins
      print "Creating Plugin Manager... "
      STDOUT.flush
      plug = Plugin_manager.new(configs.plugin_dir)
      puts "done"

      # initial connect
      bot.connect
      puts "Connected to"
      puts "	↪ network = #{bot.network}"
      puts "	↪ port = #{bot.port}"

      if configs.use_ssl
            bot.connect_ssl
            puts "Connecting Using a Secure Connection"
      end

      if configs.use_pass
            bot.connect_pass(configs.pass)
            puts "Connecting Using a password, #{configs.pass}"
      end

      if configs.ignore_list.length != 0
            puts "Creating Ignore List"
            configs.ignore_list.each do |a|
                  bot.add_ignore(a)
                  puts "	↪ #{a}"
            end
      end

      # send connect info
      # nickserv_pass can be empty
      bot.auth(configs.nickserv_pass)
      puts "Authenticated with"
      puts "	↪ nick = #{bot.nick_name}"
      puts "	↪ username = #{bot.user_name}"
      puts "	↪ realname = #{bot.real_name}"
      if configs.nickserv_pass != ""
            puts "	↪ identifying with #{configs.nickserv_pass}"
      end

      # joining channels
      puts "Joining"
      configs.channels.each { |a| bot.join(a); puts "	↪ #{a}"; }

      # setting admins
      puts "Adding admins"
      configs.admins.each { |a| bot.add_admin(a); puts "	↪ #{a}"; }

      # loading plugins
      puts "Loading plugins"
      configs.plugins_list.each do |a|
      	print "	↪ loading #{a}... "
      	STDOUT.flush
      	puts plug.plugin_load(a)
      end

      print "Creating Backlog... "
      STDOUT.flush
      backlog = []
      puts "done"

      if not File.exist?("./log")
            print "Creating Command and Privmsg Log File... "
            STDOUT.flush
            File.open("./log", "w+") { |fw| fw.write("Command and Privmsg LOGS") }
            puts "done"
      else
            puts "Command and Privmsg Log File Exists"
      end

      # the main loop for the socket
      puts "Starting #{bot.nick_name}"

      until bot.socket.eof? do
      	ircmsg = bot.read
      	msg = bot.parse(ircmsg)

            if msg.channel == msg.nick
                  File.write("./log", ircmsg, File.size("./log"), mode: 'a')
            end

      	if ircmsg == "PING" or bot.nick_name == msg.nick or bot.ignore.include? msg.nick
      		next
      	else

                  backlog.push(msg)

                  if msg.message_regex(/^`core refresh$/) and msg.nick == configs.dev_admin
                        load 'commands.rb'
                        cmds = Command_obj.new
                        bot.notice(msg.nick, "Core Reloaded")
                        File.write("./log", ircmsg, File.size("./log"), mode: 'a')
                        next
                  end

                  if cmds.commands(msg, bot, plug) then File.write("./log", ircmsg, File.size("./log"), mode: 'a'); next; end

                  responses = plug.check_all(msg, bot.admins, backlog)

      		responses.each { |a| if a != "" then bot.say(a) end }
            end
      end
end

main
