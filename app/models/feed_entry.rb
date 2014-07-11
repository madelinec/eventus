class FeedEntry < ActiveRecord::Base
	def self.update_from_feed(feed_url)
		feed = Feedjira::Feed.fetch_and_parse(feed_url)
  	feed.entries.each do |entry|
  		unless exists? :guid => entry.id
				create!(
  				:title			=> entry.title,
  				:summary		=> entry.summary,
  				:link				=> entry.url,
  				:published	=> entry.published,
  				:guid				=> entry.id
				)
  		end
		end
	end
end
