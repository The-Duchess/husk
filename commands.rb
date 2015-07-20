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
# This is the command functions for husk
# because of where this file is loaded by the irc bot it allows the core control
# to be updated during runtime.
#########################################################################################

load 'rirc.rb'

# regexes used to call command functions
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
                  /^`ignore /,
                  /^`unignore /,
                  /^`list ignore/,
                  /^`msg /,
                  /^`act /,
                  /^`list channels$/
                 ]

def warn(name)
      bot.notice(name, "You are not in the admin list, please contact an admin for help.")
      bot.notice(name, "admins:")
      admins.each { |a| bot.notice(name, "  ↪ #{a}") }
end

# based on message.message_regex(command_prefix[i]) call appropriate functions
# returns true if any functions were used
def commands(message)

      commands_reg = Regex.union(command_prefix)
      if message.message_regex(commands_reg)
            # perform one of the commands
      else
            return false
      end

      return true

end

def info
      bot.notice(msg.nick, "this is an instance of the Husk irc bot. instance nick: #{bot.nicl_name}")
      bot.notice(msg.nick, "  ↪ is a modular/plugable irc bot with a reloadable core")
      bot.notice(msg.nick, "  ↪ is a fully configurable irc bot with ssl and server pass support")
      bot.notice(msg.nick, "  ↪ is based on the rirc framework (https://github.com/The-Duchess/ruby-irc-framework)")
      bot.notice(msg.nick, "  ↪ is open source under the MIT license")
      bot.notice(msg.nick, "  ↪ can be found here https://github.com/The-Duchess/husk")
end

def join(message)

      if !admins.include? message.nick
            warn(message.nick)
            return
      end

      tokens = message.message.split(" ")

      if !tokens[1].to_s.match("/^#/") then bot.notice(message.nick, "#{tokens[1] is an invalid channel name}"); return; end

      bot.join("#{tokens[1]}")
end

def part(message)

      if !admins.include? message.nick
            warn(message.nick)
            return
      end

      bot.part(message.channel, "")
end

def quit(message)

      if !admins.include? message.nick
            warn(message.nick)
            return
      end

      bot.quit("")

      abort
end

def help(message)

end

def load(message)

end

def unload(message)

end

def reload(message)

end

def list_plugins(message)

end

def ignore(message)

end

def unignore(message)

end

def list_ignore(message)

end

def send_msg(message)

end

def send_act(message)

end

def list_channels(message)

end
