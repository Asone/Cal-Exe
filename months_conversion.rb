#!/usr/bin/env ruby
# encoding: utf-8
def monthstonbr(m)
	case m.to_s
		when "janvier"
			return 1
		when "février"
			return 2
		when "mars"
			return 3
		when "avril"
			return 4
		when "mai"
			return 5
		when "juin"
			return 6
		when "juillet"
			return 7
		when "août"
			return 8
		when "septembre"
			return 9
		when "octobre"
			return 10
		when 'novembre'
			return 11
		when 'décembre'
			return 12
		else
			return false
	end
end