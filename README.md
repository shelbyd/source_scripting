# SourceScripting

Scripting helpers for Valve Source games. Team Fortress 2, CS:GO, etc.

## Installation

Install Ruby.

Install it:

    $ gem install source_scripting

## Usage

Make a source scripting file (commands.ss). The following script will make `T` buy an ak47 and `H` do a jump smoke.

```ruby
bind :t "buy ak47"

bind :h do |action|
  action.on do |a|
    a "+jump"
    a "-attack"
  end

  action.off do |a|
    a "-jump"
  end
end
```

Run:

    $ source_scripting commands.ss path/to/your/autoexec.cfg

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shelbyd/source_scripting.
