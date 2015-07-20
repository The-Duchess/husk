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
require_relative 'config.rb'

class Config_obj
      include Config_var
end

def main

      # regexes used to call command functions
      # unless you are going to add command functions to commands do not touch this
      command_prefix = [
                        /^`info$/,
                        /^`join ##?/,
                        /^`part$/,
                        /^`plsgo$/,
                        /^`help /,
                        /^`help$/,
                        /^`load /,
                        /^`unload /,
                        /^`reload /,
                        /^`list$/,
                        /^`list channels$/,
                        /^`list admins$/
                       ]

                       #/^`ignore /,
                       #/^`unignore /,
                       #/^`list ignore/,
                       #/^`msg /,
                       #/^`act /,

      configs = Config_obj.new

      # create the bot
      print "creating bot... "
      STDOUT.flush
      bot = IRCBot.new(configs.network, configs.port, configs.nick, configs.username, configs.realname)
      puts "done"

      # create the plugin manager and tell it where to look for plugins
      print "creating plugin manager... "
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
            puts "Connecting Using a password, #{pass}"
      end

      to_ignore = []

      if configs.ignore_list.length != 0
            puts "Creating Ignore List"
            configs.ignore_list.each do |a|
                  to_ignore.push(a)
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
      puts "	↪ identifying with #{configs.nickserv_pass}"

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

      puts "Creating Backlog"
      backlog = []

      # the main loop for the socket
      puts "Starting #{bot.nick_name}"

      def warn(name, bot)
            bot.notice(name, "You are not in the admin list, please contact an admin for help.")
            bot.notice(name, "admins:")
            admins.each { |a| bot.notice(name, "  ↪ #{a}") }
      end

      # based on message.message_regex(command_prefix[i]) call appropriate functions
      # returns true if any functions were used
      def commands(message, bot, plug, command_prefix)

            commands_reg = Regexp.union(command_prefix)
            if message.message_regex(commands_reg)
                  i = 1
                  command_prefix.each do |a|
                        if message.message_regex(a)
                              if i == 1
                                    info_g(message, bot)
                              elsif i == 2
                                    join(message, bot)
                              elsif i == 3
                                    part(message, bot)
                              elsif i == 4
                                    quit(message, bot)
                              elsif i == 5
                                    help_plugin(message, bot, plug)
                              elsif i == 6
                                    help_g(message, bot)
                              elsif i == 7
                                    load_p(message, bot, plug)
                              elsif i == 8
                                    unload(message, bot, plug)
                              elsif i == 9
                                    reload(message, bot, plug)
                              elsif i == 10
                                    list_plugins(message, bot, plug)
                              elsif i == 11
                                    list_channels(message, bot)
                              elsif i == 12
                                    list_admins(message, bot)
                              else
                                    # oh shit
                              end
                        end

                        i = i + 1
                  end
            else
                  return false
            end

            return true
      end

      def info_g(msg, bot)
            bot.notice(msg.nick, "this is an instance of the Husk irc bot. instance nick: #{bot.nicl_name}")
            bot.notice(msg.nick, "  ↪ is a modular/plugable irc bot")
            bot.notice(msg.nick, "  ↪ is a fully configurable irc bot with ssl and server pass support")
            bot.notice(msg.nick, "  ↪ is based on the rirc framework (https://github.com/The-Duchess/ruby-irc-framework)")
            bot.notice(msg.nick, "  ↪ is open source under the MIT license")
            bot.notice(msg.nick, "  ↪ can be found here https://github.com/The-Duchess/husk")
      end

      def join(message, bot)

            if !bot.admins.include? message.nick
                  warn(message.nick)
                  return
            end

            tokens = message.message.split(" ")

            if !tokens[1].to_s.match("/^#/") then bot.notice(message.nick, "#{tokens[1]} is an invalid channel name"); return; end

            bot.join("#{tokens[1]}")
            # bot.notice("#{tokens[1]}", "hello: for help with this bot use `help")
      end

      def part(message, bot)

            if !bot.admins.include? message.nick
                  warn(message.nick)
                  return
            end

            bot.part(message.channel, "")
      end

      def quit(message, bot)

            if !bot.admins.include? message.nick
                  warn(message.nick)
                  return
            end

            bot.quit("")

            abort
      end

      def help_plugin(message, bot, plug)

            tokens = message.message.split(" ")
            help = plug.plugin_help(tokens[1])
            if help != nil
                  bot.notice(message.nick, help)
            else
                  bot.notice(message.nick, "plugin #{tokens[1]} not found")
            end
      end

      def help_g(message, bot)
            bot.notice(message.nick, "commands")
            bot.notice(message.nick, "  ↪ `help <plugin name> : help on the plugin")
            bot.notice(message.nick, "  ↪ `info : for information on the bot")
            bot.notice(message.nick, "  ↪ `list : lists active plugins by name")
      end

      def load_p(message, bot, plug)

            if !bot.admins.include? message.nick
                  warn(message.nick)
                  return
            end

            tokens = message.message.split(" ")
            response = plug.plugin_load(tokens[1])
            bot.notice(message.nick, response)
      end

      def unload(message, bot, plug)

            if !bot.admins.include? message.nick
                  warn(message.nick)
                  return
            end

            tokens = message.message.split(" ")
            response = plug.unload(tokens[1])
            bot.privmsg(message.nick, response)
      end

      def reload(message, bot, plug)

            if !bot.admins.include? message.nick
                  warn(message.nick)
                  return
            end

            tokens = message.message.split(" ")
            response = plug.reload(tokens[1])
            bot.notice(message.nick, response)
      end

      def list_plugins(message, bot, plug)

            if plug.get_names.length == 0 then bot.notice(message.nick, "no plugins are loaded"); return; end

            bot.notice(message.nick, "Loaded Plugins")
            plug.get_names.each { |a| bot.notice(message.nick, "  ↪ #{a}") }
      end

      def list_channels(message, bot)

            if bot.channels.length == 0 then bot.notice(message.nick, "#{bot.nick_name} is not in any channels"); return; end

            bot.notice(message.nick, "Active Chans")
            bot.channels.each { |a| bot.notice(message.nick, "  ↪ #{a}") }

      end

      def list_admins(message, bot)

            if bot.admins.length == 0 then bot.notice(message.nick, "#{bot.nick_name} does not have any admins"); return; end

            bot.notice(message.nick, "Admins")
            bot.admins.each { |a| bot.notice(message.nick, "  ↪ #{a}") }
      end

      #def ignore(message)

      #end

      #def unignore(message)

      #end

      #def list_ignore(message)

      #end

      #def send_msg(message)

      #end

      #def send_act(message)

      #end

      until bot.socket.eof? do
      	ircmsg = bot.read
      	msg = bot.parse(ircmsg)

      	if ircmsg == "PING" or bot.nick_name == msg.nick or to_ignore.include? msg.nick
      		next
      	else
                  if msg.message_regex(/^`core refresh$/) and msg.nick == configs.dev_admin
                        load 'commands.rb'
                        bot.notice(msg.nick, "Core Reloaded")
                        next
                  end

                  if commands(msg, bot, plug, command_prefix) then next end

                  responses = plug.check_all(msg, bot.admins, backlog)

      		responses.each { |a| if a != "" then bot.say(a) end }
            end
      end
end

main
