<!--data 2023-01-14 #indieweb #programming -->

# Indieweb Goofin'

My curiosity of the indieweb continues.
[Indiekit](https://getindiekit.com/) was the latest area of exploration. 

Indiekit is ultimately a bust for me. 
Running a Node application connected to MongoDB is more complexity than I want to take on.
Giving deployment a fair shot via [Render](https://render.com) was educational.
The source code even more so.
I'm glad it exists.

[Indiekit's introduction](https://getindiekit.com/introduction) was helpful for identifying the three distinct areas I can look into.

1. Micropub
2. Webmentions
3. Syndication

I'm initially intrerested in implementing Micropub.
My ideal workflow is two steps.

1. Add my website as a Micropub account in iA Writer
2. Publish directly from iA Writer

I'll need a Micropub endpoint to accomplish this.
A long-running process deployed on Render (or similar) is one possibility.
A Netlify function (or similar) is another.

The traffic to my micropub endpoint will be minimal.
Me publishing notes and links a few times a day.
I could build a full-blow Rails application.
That's the tool I know.
Deploying via Netlify function right next to my site seems fun.

Micropub authentication is OAuth 2.0 bearer tokens.
I publish my content in Github.
Could I simply issue myself an OAuth token from GitHub?
I don't need to build the generalized system for all websites to use Micropub.
I want to be able to publish from my tools to my site.

So that's the current plan of exploration.
Can I publish a note to my site using iA Writer?