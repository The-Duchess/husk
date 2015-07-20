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
# This is the Config File for husk
#########################################################################################

module Config_var

      attr_accessor :network
      attr_accessor :port
      attr_accessor :use_ssl
      attr_accessor :pass
      attr_accessor :nick
      attr_accessor :username
      attr_accessor :realname
      attr_accessor :use_pass
      attr_accessor :nickserv_pass
      attr_accessor :dev_admin
      attr_accessor :channels
      attr_accessor :admins
      attr_accessor :ignore_list
      attr_accessor :plugins_list
      attr_accessor :plugin_dir

      def initialize
            # irc server address
            @network = "irc.freenode.net"

            # irc server port
            @port = 6697

            # whether the irc bot should use ssl or not
            @use_ssl = true

            # irc server password
            @pass = ""

            # irc bot nickname
            @nick = "husk"

            # irc bot user name
            @username = "rircbot"

            # irc bot real name
            @realname = "rircbot"

            # whether the irc bot should use a password for the irc server or not
            @use_pass = false

            # irc bot nickserv password
            @nickserv_pass = ""

            # nick for core control reloading
            @dev_admin = "YOURNICK"

            # channels for the irc bot to join
            @channels = ["#YOURCHANNEL"]

            # list of admins by nick
            @admins = ["YOURNICK", "YOUROTHERNICK"]

            # list of ignored nicks
            @ignore_list = []

            # list of plugins to load
            @plugins_list = ["update.rb", "stats.rb", "youtube.rb", "urbdict.rb"]

            # file path to plugin directory
            @plugin_dir = "./plugins"
      end
end
