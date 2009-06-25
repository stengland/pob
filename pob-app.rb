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


configure do
  # Configure stuff here you'll want to
  # only be run at Heroku at boot

  feed_urls = ["http://feeds.feedburner.com/PaulDixExplainsNothing", "http://feeds.feedburner.com/trottercashion"]
  Feeds = Feedzirra::Feed.fetch_and_parse(feed_urls)
end

# Quick test
get '/' do
  updated_feeds = Feedzirra::Feed.update(Feeds.values)
  
  erb :index, :locals => {:feeds => updated_feeds}
end