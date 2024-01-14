<!--data 2022-11-08 -->

# Looking for an Indieweb Failure

I aspire to do the indieweb thing.
Having a [micropub](https://micropub.net) endpoint to publish with a client like iA Writer sounds pretty nice.
Tonight I tried to dig in.
And I'm maybe more confused then when I started.

Maybe it's me. 
(...hi...I'm the problem it's me?)
Following the breadcrumbs of [indieweb.org](https://indieweb.org) did not leave me with a clear path on what I need to do.

I don't code so much these days.
So the idea of building a `/micropub` endpoint sounds really fun!
So I downloaded [the source](https://github.com/aaronpk/micropub.rocks) of [micropub.rocks](https://micropub.rocks).
Which turned into running `brew update` and `brew upgrade` for the first time in...a while.
Then `brew install php` for the first time in...ever. 
I used to develop PHP sites using [MAMP](https://www.mamp.info/en/mac/). 
Is that still a thing?
I then installed `composer` to run `composer install` in the project folder.
Which I gather is the `bundle install` of PHP land.
I infer this because dependencies were unresolvable. 
`mailgun-php` was locked to a version that doesn't support PHP 8.
So I had to downgrade to PHP 7.
And many other such steps like these.

I eventually got micropub.rocks running locally. 
I'm not sure how to run the test suite yet.

But it did make me dream about building an easier to setup test suite for micropub.

Here's the instructions I want to write for a hypothetical micropub test suite I would build.

```
# setup the development environment dependencies
brew install ruby
gem install bundler

# setup the micropub test suite
git clone git@github.com:danott/micropub.test.git
cd micropub.test
bundle install

# run the test suite against a production micropub endpoint
rake test ENDPOINT=https://www.danott.co/micropub

# but most likely I actually want to run against a development endpoint
# my local server is probably running in another terminal tab
rake test ENDPOINT=https://localhost:3000
```

This command-line kid  doesn't want to run a web gui with a database to migrate to run a test suite.

Maybe I should just use some off the shelf blogging software.