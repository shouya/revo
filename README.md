# Revo
__for my another implementation of revo please check
[another repo](https://github.com/shouya/revo-old).__

Revo is a programming language derived from scheme. And this repo is
on purpose to implement it in Ruby.

Revo is mostly compatible with r5rs, while beside it may have some
extensions.

Demo: http://asciinema.org/a/1938

## Requirements
You need to have the following environment in order to setup revo.

- Linux or Windows, most versions should be acceptable
- Ruby 1.9+
- Bundler (`$ gem install bundler`)

For Debian/Ubuntu users: to build racc native extension you probably need to install 'ruby-dev' package.

## Installation

    $ bundle install
    $ rake compile

## Usage
Revo provides an interactive command line interface, you can run it
directly with:

    $ bundle exec bin/revi

If you have a revo source file and want it to be interpreted, knock:

    $ bundle exec bin/revo <your-source-file.revo>

## License
The MIT License (MIT)

Copyright (c) 2013 Shou Ya

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
