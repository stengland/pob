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
     "http://propertyofbristol.blogspot.com/feeds/posts/default?alt=rss",
     "http://gdata.youtube.com/feeds/base/users/PropertyofBristol/uploads?alt=rss&v=2&orderby=published&client=ytapi-youtube-profile"
  ]
  Feeds = Feedzirra::Feed.fetch_and_parse(feed_urls)
end

# Quick test
get '/' do
  # Cache for 5 minutes
  response.headers['Cache-Control'] = 'public, max-age=300'
  
  updated_feeds = Feedzirra::Feed.update(Feeds.values)
  entries = []
  
  updated_feeds.each{ |f| entries = entries + f.entries }
  
  entries.sort!{ |a,b| b.published.to_time <=> a.published.to_time  }
 
  erb :index, :locals => {:entries => entries}

end


get '/about' do 
  # Cache for 1 day
  response.headers['Cache-Control'] = 'public, max-age=86400'
  erb :about
end

get '/contact' do 
  # Cache for 1 day
  response.headers['Cache-Control'] = 'public, max-age=86400'
  erb :contact
end

get '/events' do 
  erb :events
end

get '/shop' do 
  erb :shop
end

get '/podcasts' do 
  erb :podcasts
end
