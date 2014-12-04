#!/usr/bin/env ruby
# encoding: utf-8
def create_calendar(agenda)
	p agenda.length

	for x in 0..agenda.length-1
		p agenda[x]['nom']
		ag = agenda[x]['agenda']
		filename = 'agenda_' + x.to_s
		p ag.length
		cal = Icalendar::Calendar.new
		for y in 0..ag.length-1
		p "moo"
			for z in 0..agenda[x]['agenda'][y]['events'].length-1
			p "yeah"
				cal.event do |o| 
				p "ohai"
					# p agenda[x]['agenda'][y]['events'][z]['epoch_time'].to_i
					o.dtstart = Icalendar::Values::Date.new(agenda[x]['agenda'][y]['events'][z]['epoch_time'].to_s)
					o.dtend = Icalendar::Values::Date.new(agenda[x]['agenda'][y]['events'][z]['epoch_time'].to_s)
					o.summary = Icalendar::Values::Date.new(agenda[x]['agenda'][y]['events'][z]['content'].to_s)
					o.description = "Ad lorem ipusm dolor sit amet"
				end
				
				cal.publish
				p cal
			end 
		end
	end

end