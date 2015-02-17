class FeedEntry < ActiveRecord::Base
	
	def self.update_from_feed(feed_url)
		feed = Feedjira::Feed.fetch_and_parse(feed_url)
		add_entries(feed.entries)
	end

	def self.parse_address_from_summary(summary)
		html = Nokogiri::HTML(summary)
		html.css("p").children[0] + html.css("p").children[2] + html.css("p").children[4]
	end

	def self.update_from_feed_continuously(feed_url, delay_interval = 15.minutes)
		feed = Feedjira::Fetch.fetch_and_parse(feed_url)
		add_entries(feed.entries)
		loop do
			sleep delay_interval.to_i
			feed = Feedjira::Feed.update(feed)
			add_entries(feed.new_entries) if feed.updated?
		end
	end

	private

	def self.add_entries(entries)
  	entries.each do |entry|
  		unless exists? :guid => entry.id
				create!(
  				:title			=> entry.title,
  				:summary		=> entry.summary,
  				:link				=> entry.url,
  				:published	=> entry.published,
  				:guid				=> entry.id,
  				:s_event_start => entry.categories
				)
  		end
		end
	end



end
