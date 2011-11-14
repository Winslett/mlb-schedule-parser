require 'rubygems'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/mlb'
require File.dirname(__FILE__) + '/../lib/milb'

require 'shoulda'


class Test::Unit::TestCase
  def xml_path(xml)
    File.expand_path(File.dirname(__FILE__)) + xml
  end
end
