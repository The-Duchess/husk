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
                  /^`part /,
                  /^`part$/,
                  /^`plsgo /,
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

end

def join(message)

end

def part(message)

end

def quit(message)

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
