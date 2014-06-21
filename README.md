# Capistrano::chruby

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano', '~> 3.2'
    gem 'capistrano-chruby'

And then execute:

    $ bundle install

## Usage

    # Capfile
    require 'capistrano/chruby'


    # config/deploy.rb
    set :chruby_ruby, 'ruby-2.0.0-p247'

If your `chruby-exec` is located in some custom path, you can tweak `chruby_exec` option to set it.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
