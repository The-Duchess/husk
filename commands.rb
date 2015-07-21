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
# This is the commands file for husk
#########################################################################################

module Command_mod

      def initialize
            @command_prefix = [
                              /^`info$/,
                              /^`join ##?/,
                              /^`part$/,
                              /^`plsgo$/,
                              /^`help (\S+)/,
                              /^`help$/,
                              /^`load (\S+)/,
                              /^`unload (\S+)/,
                              /^`reload (\S+)/,
                              /^`list$/,
                              /^`list channels$/,
                              /^`list admins$/,
                              /^`ignore (\S+)/,
                              /^`unignore (\S+)/,
                              /^`list ignore/,
                              /^`nick (\S+)/
                             ]

                             #/^`msg /,
                             #/^`act /,
      end

      def warn(name, bot)
            bot.notice(name, "You are not in the admin list, please contact an admin for help.")
            bot.notice(name, "admins:")
            bot.admins.each { |a| bot.notice(name, "  ↪ #{a}") }
      end

      def commands(message, bot, plug)

            commands_reg = Regexp.union(@command_prefix)
            if message.message_regex(commands_reg)
                  i = 1
                  @command_prefix.each do |a|
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
                              elsif i == 13
                                    ignore(message, bot)
                              elsif i == 14
                                    unignore(message, bot)
                              elsif i == 15
                                    list_ignore(message, bot)
                              elsif i == 16
                                    nick_change(message, bot)
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
            bot.notice(msg.nick, "this is an instance of the Husk irc bot. instance nick: #{bot.nick_name}")
            bot.notice(msg.nick, "  ↪ is a modular/plugable irc bot with reloadable commands")
            bot.notice(msg.nick, "  ↪ is a fully configurable irc bot with ssl and server pass support")
            bot.notice(msg.nick, "  ↪ is based on the rirc framework (https://github.com/The-Duchess/ruby-irc-framework)")
            bot.notice(msg.nick, "  ↪ is open source under the MIT license")
            bot.notice(msg.nick, "  ↪ can be found here https://github.com/The-Duchess/husk")
      end

      def join(message, bot)

            if !bot.admins.include? message.nick
                  warn(message.nick, bot)
                  return
            end

            tokens = message.message.split(" ")

            if !tokens[1].to_s.match("/^#/") then bot.notice(message.nick, "#{tokens[1]} is an invalid channel name"); return; end

            bot.join("#{tokens[1]}")
            # bot.notice("#{tokens[1]}", "hello: for help with this bot use `help")
      end

      def part(message, bot)

            if !bot.admins.include? message.nick
                  warn(message.nick, bot)
                  return
            end

            bot.part(message.channel, "")
      end

      def quit(message, bot)

            if !bot.admins.include? message.nick
                  warn(message.nick, bot)
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
                  warn(message.nick, bot)
                  return
            end

            tokens = message.message.split(" ")
            response = plug.plugin_load(tokens[1])
            bot.notice(message.nick, response)
      end

      def unload(message, bot, plug)

            if !bot.admins.include? message.nick
                  warn(message.nick, bot)
                  return
            end

            tokens = message.message.split(" ")
            response = plug.unload(tokens[1])
            bot.privmsg(message.nick, response)
      end

      def reload(message, bot, plug)

            if !bot.admins.include? message.nick
                  warn(message.nick, bot)
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

      def ignore(message, bot)

            if !bot.admins.include? message.nick
                  warn(message.nick, bot)
                  return
            end

            tokens = message.message.split(" ")

            bot.add_ignore(tokens[1].to_s)
            bot.notice(message.nick, "#{tokens[1]} added to ignore list")
      end

      def unignore(message, bot)

            if !bot.admins.include? message.nick
                  warn(message.nick, bot)
                  return
            end

            tokens = message.message.split(" ")

            bot.remove_ignore(tokens[1].to_s)
            bot.notice(message.nick, "#{tokens[1]} removed from ignore list")
      end

      def list_ignore(message, bot)

            if !bot.admins.include? message.nick
                  warn(message.nick, bot)
                  return
            end

            bot.notice(message.nick, "List of Ignored Users")
            bot.ignore.each { |a| bot.notice(message.nick, "  ↪ #{a}") }
      end

      def nick_change(message, bot)

            if !bot.admins.include? message.nick
                  warn(message.nick, bot)
                  return
            end

            tokens = message.message.split(" ")

            bot.notice(message.nick, "Changing bot nick from #{bot.nick_name} to #{tokens[1]}")
            bot.nick(tokens[1].to_s)
      end

      #def send_msg(message)

      #end

      #def send_act(message)

      #end

end

class Command_obj
      include Command_mod
end
