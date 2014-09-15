#!/usr/bin/env ruby
# encoding: utf-8
require 'nokogiri' # Nokogiri for scrapping html
require 'open-uri' # this for retrieving web content
require 'json' # json ftw ! 
require 'yaml' # yaml just in case 
require 'date' # this so we can play with dates and time
require 'icalendar' # a lovely gem so we can generate .ics files

require_relative('months_conversion.rb') # to convert french months name into months nbr
require_relative('calendar_gen.rb') # the calendar generator

# URL de présentation de l'ensemble du gouvernement 
root = 'http://www.gouvernement.fr'
root_url = 'http://www.gouvernement.fr/institutions/composition-du-gouvernement' 

# Get global page
gouv = Nokogiri::HTML(open(root_url)) 
membres = gouv.css('.block')

# Iterate through each gov member 
agenda_gouv = []
membres.each do |item|

	# Build minister profile 
	membre = {'nom' => item.css('.min-name').text, 'titre' => item.css('h2').text }
	
	# Scrap links to each minister profile 
	agenda_membre = item.css('a').map{ |link| link['href'] }[0]
	
	# get their agenda page 
	page_agenda = Nokogiri::HTML(open(root + agenda_membre + '?p=agenda'))

	# Extract agenda part of the page 
	
	agenda = page_agenda.css('.node-type-agenda')
	
	# loop through dat shit so we scrap the days and events
	
	u = 0
	dates = []
	
	# for each day
	agenda.css('h3').each do |i|
		
		# Extract day and month
		
		d = i.text.match(/([0-9]{1,2}) (.+) /)

		# Get Events 

		events = agenda.css('p')[u]
		
		# split events
		
		events = events.text.gsub(/\n/, ';').split(/;/)
		ev = []
		
		# extract time and split event content
		# Todo : next year case 
	
		for k in 0..(events.length-1) do
		
			# Get time of event
		
			t = events[k].match(/[0-9]{1,2}h/)
			
			# if there's time
			
			if t
				
			# p events[k].match(/([0-9]{1,2})h([0-9]{1,2})?/)
				agenda_hour = events[k].match(/([0-9]{1,2})h([0-9]{1,2})?/)[1].to_i
				
			# extract minutes if theres some 
			
				if(events[k].match(/([0-9]{1,2})h([0-9]{1,2})?/)[2])
					agenda_min = events[k].match(/([0-9]{1,2})h([0-9]{1,2})?/)[2]
				else
					agenda_min = 0
				end
				
				event_time = DateTime.new(Date.today.strftime("%Y").to_i,monthstonbr(d[2].gsub(/\ +$/,'').to_s).to_i,d[1].to_i,agenda_hour,agenda_min.to_i,0)
				 
			else 
				# if no time given 
				 event_time = DateTime.new(Date.today.strftime("%Y").to_i,monthstonbr(d[2].gsub(/\ +$/,'').to_s).to_i,d[1].to_i,0,0,0)
			end
		
			evD = {'time' => event_time.to_s ,'epoch_time' => event_time.strftime('%s').to_s ,'content' => events[k].gsub(/[0-9]{1,2}h([0-9]{1,2})? :/,'') }
			ev.push(evD)
		end
		
		# push events into dates array
		
		date = { 'date' => d[1].to_s + '/' + monthstonbr(d[2].gsub(/\ +$/,'').to_s).to_s + '/' + Date.today.strftime("%Y"), 'events' => ev }
		dates.push(date)
		u = u+1	
	end
	membre['agenda'] = dates
	# Here we'll push dates array into minister object
	agenda_gouv.push(membre)
	
end

# lets write our scrapped data into a lovely json file

File.open('agenda_gouv.json', 'w') {|f| f.write agenda_gouv.to_json } 

# for now we'll create agenda on the fly. Todo : dump data into a db so we can make it long time calendar. Yes, that's the plan brofo :)

create_calendar(agenda_gouv)

p 'CALENDAR GENERATED FAGGET !'
