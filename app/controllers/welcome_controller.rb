class WelcomeController < ApplicationController

  def index
  	@entries = FeedEntry.all(:limit => 100, :order => "published asc")
  	@event_details = Hash.new
  	@locations = Array.new
  	@event_summaries = Hash.new

  	date_regex = /(Monday|Tuesday|Wednesday|Thursday|Friday), (January|February|March|April|May|June|July|August) (\d){1,2}, (\d){4}/
  	address_regex = /<br \/>(\d)+ ((\w)+ )+(\w)+<br \/>(\w)+(,)? MA (\d){5,}/

  	@entries.each do |entry| 
  		summary = entry.summary
  		title = entry.title

  		@event_summaries[title] = summary

  		# match returns MatchData or nil
  		date = date_regex.match(summary)
  		html_address = address_regex.match(summary)

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
