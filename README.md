MT940
======

<a href='http://travis-ci.org/dovadi/mt940'>
![http://travis-ci.org/dovadi/mt940](https://secure.travis-ci.org/dovadi/mt940.png)
</a>

Basis parser for MT940 files, see [MT940](http://nl.wikipedia.org/wiki/MT940). This library is only meant for collection the transactions. No bank statements or balance (previous or new) is determined.

The following Dutch banks are implemented with support for IBAN numbers:

* ABN Amro
* ING
* Rabobank
* Triodos

Usage
=====

With the file name as argument:

    file_name = '/Users/dovadi/Downloads/ing.940'

    @transactions = MT940::Parser.new(file_name).transactions

or with the file itself:

    file_name = '/Users/dovadi/Downloads/ing.940'

    file = File.open(file_name)

    @transactions = MT940::Parser.new(file).transactions


* Independent of the bank, a transaction always consists of:

  - accountnumber (BBAN or IBAN)
  - bank (for example Ing, Rabobank etc )
  - date
  - amount (which is negative in case of a withdrawal)
  - description
  - contra account

  (Pre sepa: with the Rabobank the contra_account owner is extracted as well)

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

Copyright (c) 2014 Frank Oxener. See LICENSE.txt for further details.

