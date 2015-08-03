# **husk**

 Author: Alice "Duchess" Archer

 Copyright (c) 2015 Isaac Archer under the MIT License

Project Name: Husk

Project Description:

>Husk is a configurable irc bot using rirc [framework](https://github.com/The-Duchess/ruby-irc-framework)

>- it is configured via a ruby [script](https://github.com/The-Duchess/husk/blob/master/config.rb) file that sets variables for the irc bot

>- it is plugable using the plugin design and manager in rirc

>- it has a core set of [commands](https://github.com/The-Duchess/husk) to change state of the bot that can be reloaded during runtime for updates making it truly modular so it never has to restart.

Plugins

- [sed](https://github.com/The-Duchess/husk/blob/master/plugins/sed.rb) style search replace; note: requires linux core utils

- system [stats](https://github.com/The-Duchess/husk/blob/master/plugins/stats.rb); note: requires linux core utils

- git pull [update](https://github.com/The-Duchess/husk/blob/master/plugins/update.rb) plugin; note: requires git to be in your path

- [urban dictionary](https://github.com/The-Duchess/husk/blob/master/plugins/urbdict.rb) search; note: requires some libraries

>- require 'cgi'

>- require 'json'

>- require 'open-uri'

- [YouTube](https://github.com/The-Duchess/husk/blob/master/plugins/youtube.rb) video information; note: requires some libraries and gems

>- require 'google/api_client'

>- require 'json'

>- require 'uri'

>- require 'net/http'

>- require 'multi_json'

>- require 'date'

- [weather](https://github.com/The-Duchess/husk/blob/master/plugins/weather.rb) weather; note requires some libraries and gems

>- require 'net/http'

>- require 'optparse'

>- require 'open-uri'

>- require 'json'

>- require 'date'
