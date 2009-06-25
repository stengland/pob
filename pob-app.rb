# You'll need to require these if you
# want to develop while running with ruby.
# The config/rackup.ru requires these as well
# for it's own reasons.
#
# $ ruby heroku-sinatra-app.rb
#
require 'rubygems'
require 'sinatra'
require 'feedzirra'

class String
  
  def to_time(form = :utc)
    ::Time.send("#{form}_time", *::Date._parse(self, false).values_at(:year, :mon, :mday, :hour, :min, :sec).map { |arg| arg || 0 })
  end
  
end

configure do
  # Configure stuff here you'll want to
  # only be run at Heroku at boot

  feed_urls = [
    "http://feeds2.feedburner.com/slashfilm",
    "http://twitter.com/statuses/user_timeline/10535832.rss",
    "http://api.flickr.com/services/feeds/photos_public.gne?id=85694872@N00&lang=en-us&format=atom"
  ]
  Feeds = Feedzirra::Feed.fetch_and_parse(feed_urls)
end

# Quick test
get '/' do
  updated_feeds = Feedzirra::Feed.update(Feeds.values)
  entries = []
  
  updated_feeds.each{ |f| entries = entries + f.entries }
  
  entries.sort!{ |a,b| b.published.to_time <=> a.published.to_time  }
  
  erb :index, :locals => {:entries => entries}
end