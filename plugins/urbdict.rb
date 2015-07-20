#!/bin/env ruby
# urban dict mod
# author: apels <Alice Duchess>
# module as defined by plugin.rb
# this module searches urban dictionary for your word.

require 'cgi'
require 'json'
require 'open-uri'
require 'openssl'
load 'rirc.rb'

class UrbDict < Pluginf
	#any functions you may need
	#retrieves the first description

	#your definition for script
	def script(message, admins, backlog)

		@r = ""
		@srh = ""
		@rt = ""
		message.message[4..-1].split(" ").each { |a| @srh.concat("#{a.to_s}+")}
		uri = "http://api.urbandictionary.com/v0/define?term=%s" % @srh

		begin
			open(uri) do |f|
				obj = JSON.parse(f.read)
				if obj['list'].empty?
					@r = "No result"
					return @r
				else
					@rt = obj['list'][0]['definition'].gsub(/(\r\n)+/, ' ').to_s
				end
		end
		rescue => e
			return "an error has happened"
		end

		@parts = []
		len = 400

		len_f = @rt.length / len
		len_a = len_f.floor
		len_a +=1
		i = 0
		0.upto(len_a) do |a|
			if @rt.length <= len
				#@parts.push(@rt.to_s)
				return @rt.to_s
			end

			if(@rt[a..-1].to_s.length <= len)
				p "should be back"
				p @rt[((len * a) + i)..-1].to_s
				@parts.push(@rt[((len * a) + i)..-1])
				break
			end

			# p "mid"
			# p @rt[((len * a) + i)..((len * (a + 1)) + i)].to_s
			@parts.push(@rt[((len * a) + i)..((len * (a + 1)) + i)])

			if i == 0
				i += 1
			end
		end

		0.upto(1) do |a|
			@r.concat("#{@parts[a]}\n")
		end

		@r.concat("#{uri[0..-1]}\n")

		#@parts.each { |str| @r.concat("#{str}\n")}

		return privmsg(message.channel, "#{@r}\.\.\.")
	end

	def privmsg(dest, message)
		return "PRIVMSG #{dest} :#{message}"
	end
end

reg = /^`ud / # regex to call the plugin
filename = "urbdict.rb" # file name
pluginname = "urbdict" # name for plugin
description = "`ud <search criteria> gets a result from urban dictionary" # description and or help

# plugin = Class_name.new(regex, name, file_name, help)
# this temporary global is used for handing the new plugin back to the bot
$temp_plugin = UrbDict.new(reg, pluginname, filename, description)
