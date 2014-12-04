require 'nokogiri'
require 'open-uri'
require 'json'
 
# Get a Nokogiri::HTML:Document for the page we’re interested in...

doc = Nokogiri::HTML(open('http://www.developpement-durable.gouv.fr/spip.php?page=agendas')) 

cal  = doc.css("#agenda")
days = cal.css('#jours>.event')
semaine_ministre_ecologie = []

days.each do |item|
#puts item
	jour_ministre_ecologie = { 'day' => item.css('.date').text}
	evenements = []
	liste_evenements = item.css('.evenement')
	
	liste_evenements.each do |e|
		evenement = {'titre' => e.css('.titre').text, 'time' => e.css('.heure').text }
	#	puts evenement
		evenements.push(evenement)
	end
	jour_ministre_ecologie['events'] = evenements
	semaine_ministre_ecologie.push(jour_ministre_ecologie)
	puts jour_ministre_ecologie
end
File.open('ministres/semaine_ministre_ecologie.json', 'w') {|f| f.write semaine_ministre_ecologie.to_json } 	