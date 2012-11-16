$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'tempfile'
require 'mt940/base'
require 'mt940/transaction'
require 'mt940/banks/ing'
require 'mt940/banks/rabobank'
require 'mt940/banks/abnamro'
require 'mt940/banks/triodos'
require 'mt940/banks/deutsche_bank'