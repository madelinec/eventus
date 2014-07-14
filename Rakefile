# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Eventus::Application.load_tasks

namespace :rss do

  desc "Update database with new events from Boston Calendar RSS feed"
  task :update_from_feed => :environment do
    puts "updating database from rss feed at 'http://www.trumba.com/calendars/cob-calendar.rss'"
    FeedEntry.update_from_feed("http://www.trumba.com/calendars/cob-calendar.rss")
  end

end
