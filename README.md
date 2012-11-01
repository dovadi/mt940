MT940
======

<a href='http://travis-ci.org/dovadi/mt940'>
![http://travis-ci.org/dovadi/mt940](https://secure.travis-ci.org/dovadi/mt940.png)
</a>

Basis parser for MT940 files, see [MT940](http://nl.wikipedia.org/wiki/MT940)

The following Dutch banks are implemented:

* ABN Amro
* ING
* Rabobank
* Triodos

Usage
=====

With the file name as argument:

    file_name = '/Users/dovadi/Downloads/ing.940'

    @transactions = MT940::Base.transactions(file_name)

or with the file itself:

    file_name = '/Users/dovadi/Downloads/ing.940'

    file = File.open(file_name)

    @transactions = MT940::Base.transactions(file)


* Independent of the bank, a transaction always consists of:

  - accountnumber
  - bank (for example Ing, Rabobank or Unknown)
  - date
  - amount (which is negative in case of a withdrawal)
  - description
  - contra account

* With the Rabobank its owner is extracted as well.

Running tests
=============

> bundle install

> bundle exec rake test

Contributing to MT940
=====================
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
==========

Copyright (c) 2012 Frank Oxener - Agile Dovadi BV. See LICENSE.txt for further details.

