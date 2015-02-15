class WelcomeController < ApplicationController

  def index

  	@entries = FeedEntry.all.order('published asc').limit(50)
  	@event_dates = Hash.new
  	@locations = Array.new
  	@event_summaries = Hash.new
  	@event_links = Hash.new
  	@event_ids = Hash.new
    @event_types = Hash.new

  	

=begin
	  time_date_regex = //
	  multi_date_regex = /(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday), (January|February|March|April|May|June|July|August) (\d){1,2}, (\d){1,2}(am|pm)&nbsp;&ndash; (Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday), (January|February|March|April|May|June|July|August) (\d){1,2}, (\d){4}, (\d){1,2}(am|pm)( )?<br( )?\/>/
  	ongoing_date_regex = /(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday), (January|February|March|April|May|June|July|August) (\d){1,2}, (\d){4}/
		date_regex = /(Monday|Tuesday|Wednesday|Thursday|Friday), (January|February|March|April|May|June|July|August) (\d){1,2}, (\d){4}/
		#date_with_month_regex = /(<br( )?\/>)[^<>]*(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)[^<>]*(January|February|March|April|May|June|July|August)[^<>]*(<br( )?\/>)/	
		#date_with_br_regex = /(<br( )?\/>)[^<>]*(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)[^<>]*(<br( )?\/>)/
=end 

  	date_regex = /[^<>]*(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)[^<>]*(January|February|March|April|May|June|July|August|September|October|November|December)[^<>]*/

    type_regex = /Arts &amp; Crafts|Author Talk|Book Group|Book Sale|Community Meeting|Computers\/Technology|
    Concerts \/ Live Music|Early Literacy|Environmental Events|ESOL|Exhibition|Farmer&#39;s Market|Film|Food &amp; Dining|
    Games\/Gaming|Health \/ Fitness|Historical|Holiday Celebration|Homework Help|Meeting \/ Hearing|Nature|Non-Profit Fundraiser|
    Parades &amp; Festivals|Park Event|Performing Arts|Public Meeting \/ Hearing|Social Networking|Sports|Story Time|Talks &amp; Lectures|
    Theatre|Tours|Visual Arts|Attractions &amp; Museums|Volunteer Opportunity|Walks &amp; Races|Workshops &amp; Classes/

  	address_regex = /<br \/>(\d)+ ((\w)+ )+(\w)+<br \/>(\w)+(,)? MA (\d){5,}/

  	@entries.each do |entry| 
  		summary = entry.summary
  		title = entry.title
  		link = entry.link
  		id = entry.id

  		@event_summaries[title] = summary
  		@event_links[title] = link
  		@event_ids[title] = id

  		# match returns MatchData or nil
  		type = type_regex.match(summary)
  		date = date_regex.match(summary)
  		html_address = address_regex.match(summary)
  		
  		unless type.nil?
  		  type = type[0]
        type.gsub! "&amp;", "&"
  		  @event_types[entry.title] = type
  		end

  		unless date.nil?
  			date = date[0] # update to get all unique dates in the match array
  			date.gsub! "&nbsp;", " "
  			date.gsub! "&ndash;", "-"
  			@event_dates[entry.title] = date

  			begin
  				parsed_date = date.to_datetime
  				@event_dates[entry.title] = parsed_date.inspect
  			rescue ArgumentError
  				@event_dates[entry.title] = date
  			end
  		end

  		unless html_address.nil?
  			# get rid of the html formatting
				address = html_address[0].gsub! "<br />", " "

				# convert address to lat-lng 
        #result = Geocoder.search(address)
# commented this out bc Geocoder is over api limit
        result = nil

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

  def example_helper_method
  end
  # method can now be called from view
  helper_method :example_helper_method

end
