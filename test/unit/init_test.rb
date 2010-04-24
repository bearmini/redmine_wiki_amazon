# vim: set ts=2 sts=2 sw=2 expandtab :
mydir = File.dirname(__FILE__)
require mydir + '/../test_helper.rb'
require mydir + '/../../init.rb'

class AmazonHelperTest < Test::Unit::TestCase

  def setup
    @target = AmazonHelper.new
  end


  def args(str)
    str.split(',')
  end


  def test_builder
    assert @target.builder(:jp).is_a? AmazonUrlBuilderJp
    assert @target.builder(:hoge).is_a? AmazonUrlBuilderDefault
    assert @target.builder(nil).is_a? AmazonUrlBuilderDefault
  end


  def test_trim
    assert_equal nil, @target.trim(nil)
    assert_equal "a", @target.trim("a")
    assert_equal "a", @target.trim(" a")
    assert_equal "a", @target.trim("a ")
    assert_equal "a", @target.trim(" a ")
  end


  def test_parse_args
    assert_equal ["a", nil, :jp], @target.parse_args(args("a"))
    assert_equal ["a", "b", :jp], @target.parse_args(args("a, b"))
    assert_equal ["a", "b", :cd], @target.parse_args(args("a, b, cd"))
    assert_equal ["1234567890", "rmw-22", :jp], @target.parse_args(args("1234567890, rmw-22, jp"))
  end


  def test_get_image_url
    assert_equal "http://ec3.images-amazon.com/images/P/1234567890.09._PC_SCMZZZZZZZ_.jpg", @target.get_image_url("1234567890", :jp)
  end


  def test_get_item_url
    assert_equal "http://amazon.jp/o/ASIN/1234567890", @target.get_item_url("1234567890", nil, :jp)
    assert_equal "http://amazon.jp/o/ASIN/1234567890/rmw-22", @target.get_item_url("1234567890", "rmw-22", :jp)
  end


  def test_get_tag
    assert_equal "(No parameters specified. ASIN is needed at least)", @target.get_tag(args(""))

    assert_equal "<a href=\"http://amazon.jp/o/ASIN/1234567890\">\n  <img src=\"http://ec3.images-amazon.com/images/P/1234567890.09._PC_SCMZZZZZZZ_.jpg\" />\n</a>\n", @target.get_tag(args("1234567890"))
    assert_equal "<a href=\"http://amazon.jp/o/ASIN/1234567890/rmw-22\">\n  <img src=\"http://ec3.images-amazon.com/images/P/1234567890.09._PC_SCMZZZZZZZ_.jpg\" />\n</a>\n", @target.get_tag(args("1234567890, rmw-22"))
  end

end

