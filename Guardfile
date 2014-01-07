# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :test do
  watch(%r{^lib/mt940/banks/(.+)\.rb$}) {|m| "test/mt940_#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$}) 
  watch('test/test_helper.rb')  { "test" }
  watch('lib/mt940/base.rb')  { "test" }
  watch('lib/mt940/parser.rb')  { "test" }
end
