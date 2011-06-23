MT940
======

Basis parser for MT940 files, see [MT940](http://nl.wikipedia.org/wiki/MT940)

The following Dutch banks are implemented:

* ABN Amro
* ING
* Rabobank
* Triodos

Usage
=====

* At this moment there is no automatic determination which bank needs to be parsed. So you need to choose the corresponding MT940 subclass for the specific bank you want to parse. 

  `file_name = File.dirname(__FILE__) + 'ing.940'
  @transactions = MT940::ING.transactions(file_name)`

* Independent of the bank, a transaction always consists of an amount and a description. 
* With some implementations the contra_account with its owner is extracted as well.


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

Copyright (c) 2011 Frank Oxener - Agile Dovadi BV. See LICENSE.txt for further details.

