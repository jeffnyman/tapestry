# Tapestry

[![Build Status](https://travis-ci.org/jeffnyman/tapestry.svg)](https://travis-ci.org/jeffnyman/tapestry)
[![Gem Version](https://badge.fury.io/rb/tapestry.svg)](http://badge.fury.io/rb/tapestry)
[![License](http://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/jeffnyman/tapestry/blob/master/LICENSE.md)

[![Dependency Status](https://gemnasium.com/jeffnyman/tapestry.png)](https://gemnasium.com/jeffnyman/tapestry)

> _Nature uses only the longest threads to weave her patterns, so that each
> small piece of her fabric reveals the organization of the entire tapestry._
>
> &nbsp;&nbsp;&nbsp;&nbsp;**Richard Feynman**

The Tapestry gem serves as a micro-framework that provides a semantic DSL to construct a fluent interface for test execution libraries.

The fluent interface is designed to promote the idea of compressibility of your test logic, allowing for more factoring, more reuse, and less repetition. You can use Tapestry directly as an automated checking library or you can use it with other tools such as RSpec, Cucumber, or anything else that allows you to delegate down to a different level of abstraction.

> _There were loose threads ... untidy parts of me that I would like to
> remove. But when I pulled on one of those threads ... it unraveled the
> tapestry of my life._
>
> &nbsp;&nbsp;&nbsp;&nbsp;**Captain Jean-Luc Picard, _Star Trek: The Next Generation_ ("Tapestry")**

Tapestry is an abstraction layer on top of WebDriver, quite similar to how, say, Express is an abstraction layer on top of Node's built-in HTTP server. Just as you could, in theory, write everything with plain vanilla Node and never touch Express, you could write everything directly at the level of Selenium and never worry about Tapestry.

The whole point of an abstraction layer is to smooth out the difficult and/or fiddly bits. As such, Tapestry is actually an abstraction on top of a library called Watir (Web Application Testing in Ruby). Watir itself is an abstraction layer over Selenium which is, in turn, a particular abstraction of WebDriver.

> _We look at life from the back side of the tapestry. And most of the time,
> what we see is loose threads, tangled knots and the like. But occasionally,
> God's light shines through the tapestry, and we get a glimpse of the larger
> design with God weaving together the darks and lights of existence._
>
> &nbsp;&nbsp;&nbsp;&nbsp;**John Piper**

Tapestry is built, as are all my test-supporting tools, on the idea that automation should largely be small-footprint, low-fiction, high-yield.

The code that a test-supporting micro-framework allows should be modular, promoting both high cohesion and low coupling, as well as promoting a single level of abstraction. These concepts together lead to lightweight design as well as support traits that make change affordable. That makes the automation code less expensive to maintain and easier to change. That, ultimately, has a positive impact on the cost of change.

For code documentation, check out the [RDocs](http://www.rubydoc.info/github/jeffnyman/tapestry/frames).

For insight into construction, check out [my Tapestry posts](http://testerstories.com/category/automation/tapestry/).

## Installation

To get the latest stable release, add this line to your application's Gemfile:

```ruby
gem 'tapestry'
```

To get the latest code:

```ruby
gem 'tapestry', git: 'https://github.com/jeffnyman/tapestry'
```

After doing one of the above, execute the following command:

    $ bundle

You can also install Tapestry just as you would any other gem:

    $ gem install tapestry

## Usage

Probably the best way to get a feel for the current state of the code is to look at the examples:

* [Simple script](https://github.com/jeffnyman/tapestry/blob/master/examples/tapestry-simple.rb)
* [Factory script](https://github.com/jeffnyman/tapestry/blob/master/examples/tapestry-factory.rb)
* [Data Set script](https://github.com/jeffnyman/tapestry/blob/master/examples/tapestry-data-set.rb)
* [Events script](https://github.com/jeffnyman/tapestry/blob/master/examples/tapestry-events.rb)

You'll see references to "Veilus" and a "localhost" in the script. I'm using my own [Veilus application](https://veilus.herokuapp.com/). As far as the localhost, you can use the [Veilus repo](https://github.com/jeffnyman/veilus) to get a local copy to play around with.

If you clone this repository, you can see this script in action by running the command `rake script:simple`.

More details will be forthcoming as the project evolves.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake spec:all` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

The default `rake` command will run all tests as well as a RuboCop analysis.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/jeffnyman/tapestry](https://github.com/jeffnyman/tapestry). The testing ecosystem of Ruby is very large and this project is intended to be a welcoming arena for collaboration on yet another test-supporting tool. As such, contributors are very much welcome but are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

The Tapestry gems follows [semantic versioning](http://semver.org).

To contribute to Tapestry:

1. [Fork the project](http://gun.io/blog/how-to-github-fork-branch-and-pull-request/).
2. Create your feature branch. (`git checkout -b my-new-feature`)
3. Commit your changes. (`git commit -am 'new feature'`)
4. Push the branch. (`git push origin my-new-feature`)
5. Create a new [pull request](https://help.github.com/articles/using-pull-requests).

## Author

* [Jeff Nyman](http://testerstories.com)

## License

Tapestry is distributed under the [MIT](http://www.opensource.org/licenses/MIT) license.
See the [LICENSE](https://github.com/jeffnyman/tapestry/blob/master/LICENSE.md) file for details.
