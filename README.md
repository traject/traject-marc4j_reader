# Traject::Marc4JReader

**Note**: `Traject::Marc4JReader` is for JRuby only.

`Traject::Marc4JReader` is a reader for the [traject](https://github.com/traject-project/traject) ETL system
that allows the use of [marc4j](https://github.com/marc4j/marc4j) as a reader when dealing with MARC
binary or MARC-XML files. It is of no use outside of `traject` run under JRuby.

It leverages [marc-marc4j](https://github.com/billdueber/ruby-marc-marc4j), which is a paper-thin wrapper around
the Marc4J `.jar` that is shipped with it.

**The output of the reader is a vanilla ruby-marc object**. You can hang onto the
original marc4j java object with the `marc4j_reader.keep_marc4j` setting.


## Why use this?


The biggest reason would be for faster MARC/MARC-XML parsing and generation than the vanilla
[marc](https://github.com/ruby-marc/ruby-marc) gem can provide, or if you need to do something wacky with the marc4j
internal structure (such as feed it to legacy java code you have lying around).

In general, the marc4j library will parse marc21 (binary) and MARC-XML roughly twice
as fast as the pure-ruby library. While MARC parsing tends to not be a huge part
of the workload in a traject run, you'll almost certainly see performance gains.

## Installation

Traject prior to 3.0 included this as a dependency on JRuby, and defaulted to using it.

In Traject 3.0+, you need to manually add this gem and configure to use it.

If you are using bundler and a `Gemfile`, add `gem "traject-marc4j_reader", "~> 1.0"` to your `Gemfile`. Otherwise, just `gem install traject-marc4j_reader`.

Then, in your traject config file:

    # Instead of require in config file, you could use the `-r` traject
    # command-line option.
    require 'traject-marc4j_reader'

    settings do
      provide "reader_class_name", "Traject::Marc4JReader"

      # Recommend marc4j_reader.permissive true unless you have reason not to.
      # true was default provided by core traject gem in Traject pre-3.0.
      # Only relevant for binary MARC source data.
      provide "marc4j_reader.permissive", true
    end

## Traject::Marc4jReader settings

For more about the traject `settings` object, see [the traject settings documentation](https://github.com/traject-project/traject/blob/master/doc/settings.md)


Note that the standard Marc4JReader always converts to UTF8,
so output will always reflect that conversion.

* `marc4j.jar_dir`:   Path to a directory containing Marc4J jar file to use. All .jar's in dir will
                      be loaded. If unset, uses marc4j.jar bundled with traject.

* `marc4j_reader.permissive`: Used by Marc4JReader only when marc.source_type is 'binary', boolean, argument to the underlying MarcPermissiveStreamReader. Default false, but recommend true for most uses.

* `marc4j_reader.source_encoding`: Used by Marc4JReader only when marc.source_type is 'binary', encoding strings accepted
  by marc4j MarcPermissiveStreamReader. Default "BESTGUESS", also "UTF-8", "MARC"

* `marc4j_reader.keep_marc4j`: After translating the marc4j record into a normal ruby-marc object,
provides access to the former via `record#original_marc4j`.


## Sample use

A simple example that reads in via marc4j and outputs to the newline-delimited-json writer.

Use would be:

```bash
traject -c id_title.rb my_marc_file.mrc
```

```ruby
# File id_title.rb

require 'traject'
require 'traject/marc4j_reader'
require 'traject/json_writer'

require 'traject/macros/marc21_semantics'
extend  Traject::Macros::Marc21Semantics

settings do
  provide "reader_class_name", "Traject::Marc4JReader"
  provide "marc4j_reader.keep_marc4j", true
  provide "writer_class_name", "Traject::JsonWriter"
  provide "output_file", "ids_and_titles.ndj"
end

to_field "id", extract_marc("001", :first => true)
to_field "title", extract_marc_filing_version('245abdefghknp', :include_original => true)

```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/traject_marc4j_reader/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
