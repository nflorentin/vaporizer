# Vaporizer

Gem under construction

Will cover all endpoints of new Leafly API

## Installation

Add this line to your application's Gemfile:

    gem 'vaporizer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vaporizer
    
## Good to know

Some things to know before using this gem:
* This is my first gem, please be tolerant
* Leafly API is kind of inconsistent and do not respect rules of JSON API standard, that's not my fault
* Changes in Leafly API could break this gem, if it happens, do not hesitate to open an issue and I will fix it as fast as possible
* Vaporizer returns pure parsed JSON and do not wrap results with objects
* If you need more functionalities, do not hesitate to contact me and we will discuss it

## Configuration

```ruby
require 'vaporizer'

Vaporizer.configure do |config|
  config.app_id = "YOUR_APP_ID"
  config.app_key = "YOUR_APP_KEY"
  config.timeout = 3 # timeout for the requests, optional, in seconds
end
```
## Usage examples

### Strains

**search**
```ruby
Vaporizer::Strain.search(search: 'dream', page: 0, take: 10)
```

**more complex search**
```ruby
Vaporizer::Strain.search(
    filters: {
      flavors: ['blueberry'],
      conditions: ['anxiety']
    },
    search: '',
    page: 0, take: 10
)
```

**details**
```ruby
Vaporizer::Strain.details('la-confidential') # argument is a slug of strain's name
```

**reviews**
```ruby
Vaporizer::Strain.reviews('la-confidential', { page: 0, take: 3 })
```

**review details**
```ruby
Vaporizer::Strain.review_details('la-confidential', 2836) # 2nd argument is the review id
```

**photos**
```ruby
Vaporizer::Strain.photos('la-confidential', { page: 0, take: 4 })
```

**availabilities**
```ruby
Vaporizer::Strain.availabilities('la-confidential', { lat: 33.5, lon: -117.6 })
```

## More options

To have the list of all params and filters available of the Leafly API, please refer to
the <a href="https://developer.leafly.com/docs">official documentation</a>

## Contributing

1. Fork it ( https://github.com/[my-github-username]/vaporizer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
