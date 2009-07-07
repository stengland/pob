# "http://eventful.com/rss/users/propertyofbristol"

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
     "http://twitter.com/statuses/user_timeline/30975043.rss",
     "http://propertyofbristol.blogspot.com/feeds/posts/default?alt=rss",
     "http://api.flickr.com/services/feeds/photos_public.gne?id=39867411@N08&lang=en-us&format=rss_200",
     "http://gdata.youtube.com/feeds/base/users/PropertyofBristol/uploads?alt=rss&v=2&orderby=published&client=ytapi-youtube-profile"
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


get '/about' do 
  erb :about
end

get '/contact' do 
  erb :contact
end