require ('csv')
require ('sunlight/congress')
require ('erb')
Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"
puts "The Event Manager has been initialized!"

def clean_zipcode(zip)
# 	if zip.nil?
# 		zip = "00000"
# 	elsif zip.length < 5
# 		zip = zip.rjust(5,"0")
# 	elsif zip.length > 5
# 		zip = zip[0..4]
# 	end	
	zip.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zip)
	legislators = Sunlight::Congress::Legislator.by_zipcode(zip)
	
	legislator_names = legislators.collect do |legislator| 
		"#{legislator.first_name} #{legislator.last_name}"
	end
	#legislator_names.join(", ") 
	legislator_names
end

def save_thank_you_letter(id,form_letter)
	Dir.mkdir("output") unless Dir.exists? "output"
	filename = "output/thanks_#{id}.html"
	File.open(filename,'w') do |file| 
		file.puts form_letter	
	end
end

template_letter = File.read('../form_letter.html.erb')
erb_template = ERB.new(template_letter)
contents = CSV.open('../event_attendees.csv',headers: true, header_converters: :symbol)

contents.each do |line|
	id = line[0]
	fname = line[:first_name]
	lname = line[:last_name]
	zip = clean_zipcode(line[:zipcode])
	#clean_zipcode(zip)
	legislators = legislators_by_zipcode(zip)
	
# 	personal_letter = template_letter.gsub('FIRST_NAME'	, fname)
# 	personal_letter.gsub!("LEGISLATORS",legislators)
	form_letter = erb_template.result(binding)
	
	save_thank_you_letter(id,form_letter)
	#puts form_letter
	#puts "#{fname} #{zip}" + " Legislator: " + "#{legislators}" 
end


 #lines = File.readlines "../event_attendees.csv"
#puts lines
#  lines.each do |line|
#  	next if line == lines[0]
# 	comma = line.split(",")
# 	 puts "#{comma[2]} #{comma[3]}"
# end

#  contents = File.read "../event_attendees.csv"
#  puts contents