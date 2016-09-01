[![Build Status](https://travis-ci.org/denispeplin/rss_modifier.svg?branch=master)](https://travis-ci.org/denispeplin/rss_modifier)

# RssModifier

RSS feed experiments.

## Installation

Clone git repository. You should have [Elixir](http://elixir-lang.org/) installed.

## Usage

```
mix deps.get
mix run --no-halt
```

For the moment, only modifier is implemented.

Point a browser to http://localhost:4000/mofidy, provide `source` URL of original feed,
and two arrays: `patterns` and `replacements`.

## TODO

Front page with a form to prepare request will be provided.
