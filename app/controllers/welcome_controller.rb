class WelcomeController < ApplicationController

  def index
  	@entries = FeedEntry.all(:limit => 5, :order => "published asc")
  	@event_details = Hash.new
  	@event_type = Hash.new
  	@locations = Array.new
  	@event_summaries = Hash.new
  	@event_links = Hash.new
    
    type_regex = /Arts & Crafts|Attractions & Museums|Author Talk|Book Group Book Sale|Community Meeting|Computers\/Technology|
    Concerts \/ Live Music|Early Literacy|Environmental Events|ESOL|Exhibition|Farmer's Market|Film|Food & Dining|
    Games\/Gaming|Health \/ Fitness|Historical|Holiday Celebration|Homework Help|Meeting \/ Hearing|Nature|Non-Profit Fundraiser|
    Parades & Festivals|Park Event|Performing Arts|Public Meeting \/ Hearing|Social Networking|Sports|Story Time|Talks & Lectures|
    Theatre|Tours|Visual Arts|Volunteer Opportunity|Walks & Races|Workshops & Classes/
  	date_regex = /(Monday|Tuesday|Wednesday|Thursday|Friday), (January|February|March|April|May|June|July|August) (\d){1,2}, (\d){4}/
  	address_regex = /<br \/>(\d)+ ((\w)+ )+(\w)+<br \/>(\w)+(,)? MA (\d){5,}/

  	@entries.each do |entry| 
  		summary = entry.summary
  		title = entry.title
  		link = entry.link

  		@event_summaries[title] = summary
  		@event_links[title] = link

  		# match returns MatchData or nil
  		type = type_regex.match(summary)
  		date = date_regex.match(summary)
  		html_address = address_regex.match(summary)
  		
  		unless type.nil?
  		  type = type[0]
  		  @event_type[entry.title] = type
  		end

  		unless date.nil?
  			date = date[0]
  			@event_details[entry.id] = date
  		end

  		unless html_address.nil?
  			# get rid of the html formatting
				address = html_address[0].gsub! "<br />", " "

				# convert address to lat-lng 
				result = Geocoder.search(address)

				unless result.nil?
					unless result[0].nil?
						coords = Hash.new
		  			lng = result[0].data['geometry']['location']['lng']
		  			lat = result[0].data['geometry']['location']['lat']

		  			coords['lat'] = lat
		  			coords['lng'] = lng
		  			coords['id'] = entry.id
		  			coords['title'] = entry.title

						@locations << coords
					end
				end
  		end
  	end
  end

end
