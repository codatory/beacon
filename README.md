# What is it?
I wanted a way to track hits on my RSS feeds. Google Analytics' usage of cookies and javascript preclude using it, and I didn't want to just truncate my feeds and force users to hit my site. I thought surely there was a way to do it with a tracking image, but now that browsers block 3rd party cookies by default I had to be more clever with detecting new and returning visitors.

# The Breakthrough
Having spent all day cleaning up my blog and doing a bunch of performance tuning with caching & cache headers, I realized that the etags & if_modified_since headers would be perfect for filtering out duplicate hits.

# How does it work?
This is mostly a Proof of Concept, though I'm certainly willing to help grow it out into something more fully featured. As it stands now, it has two features.

* Tracking .gif
* JSON Api for hit data

To use it, simply deploy the app somewhere and include an `<img>` tag with the src attribute pointed to a uniquely named .gif. eg:

`<img src="http://neverwinter-autumn.herokuapp.com/myblogpost.gif" />`

The first time a browser encounters that image, the app will count a unique hit and return a 42 byte blank gif with an etag and date header. The next time a browser seed that URL it will again request it but send the etag & date headers back allowing the app to only increment the total hits column.