# vim: set ts=2 sts=2 sw=2 expandtab :
mydir = File.dirname(__FILE__)
require mydir + '/../test_helper.rb'
require mydir + '/../../init.rb'

class AmazonUrlBuilderJpTest < Test::Unit::TestCase
  def setup
    @target = AmazonUrlBuilderJp.new
  end

  def test_associate
    100.times do 
      @target.associate("hogehoge-22")
    end
    assert @target.url.include? "rmw-22"
  end

end


class AmazonHelperTest < Test::Unit::TestCase

  def setup
    @target = AmazonHelper.new(:testing)
  end


  def args(str)
    str.split(',')
  end


  def test_builder
    assert @target.builder(:jp).is_a? AmazonUrlBuilderJp
    assert @target.builder(:us).is_a? AmazonUrlBuilderUs
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
    assert_equal ["1234567890", "", :jp], @target.parse_args(args("1234567890, , jp"))
  end


  def test_get_image_url
    assert_equal "http://ec3.images-amazon.com/images/P/1234567890.09._PC_SCMZZZZZZZ_.jpg", @target.get_image_url("1234567890", :jp)
    
    assert_equal "http://ec3.images-amazon.com/images/P/1234567890.01._PC_SCMZZZZZZZ_.jpg", @target.get_image_url("1234567890", :us)
  end


  def test_get_item_url
    assert_equal "http://amazon.jp/o/ASIN/1234567890", @target.get_item_url("1234567890", nil, :jp)
    assert_equal "http://amazon.jp/o/ASIN/1234567890/", @target.get_item_url("1234567890", "", :jp)
    assert_equal "http://amazon.jp/o/ASIN/1234567890/rmw-22", @target.get_item_url("1234567890", "rmw-22", :jp)

    assert_equal "http://www.amazon.com/dp/1234567890", @target.get_item_url("1234567890", nil, :us)
    assert_equal "http://www.amazon.com/dp/1234567890/?tag=", @target.get_item_url("1234567890", "", :us)
    assert_equal "http://www.amazon.com/dp/1234567890/?tag=rmwa-20", @target.get_item_url("1234567890", "rmwa-20", :us)
  end


  def test_get_tag
    # no parameters
    assert_equal "(No parameters specified. ASIN is needed at least)", @target.get_tag(args(""))

    # only ASIN
    assert_equal "<a href=\"http://amazon.jp/o/ASIN/1234567890\">\n  <img src=\"http://ec3.images-amazon.com/images/P/1234567890.09._PC_SCMZZZZZZZ_.jpg\" />\n</a>\n", @target.get_tag(args("1234567890"))

    # ASIN and Associate ID
    assert_equal "<a href=\"http://amazon.jp/o/ASIN/1234567890/rmw-22\">\n  <img src=\"http://ec3.images-amazon.com/images/P/1234567890.09._PC_SCMZZZZZZZ_.jpg\" />\n</a>\n", @target.get_tag(args("1234567890, rmw-22"))

    # ASIN and Associate ID and country code
    assert_equal "<a href=\"http://amazon.jp/o/ASIN/1234567890/rmw-22\">\n  <img src=\"http://ec3.images-amazon.com/images/P/1234567890.09._PC_SCMZZZZZZZ_.jpg\" />\n</a>\n", @target.get_tag(args("1234567890, rmw-22, jp"))
    assert_equal "<a href=\"http://www.amazon.com/dp/1234567890/?tag=rmwa-20\">\n  <img src=\"http://ec3.images-amazon.com/images/P/1234567890.01._PC_SCMZZZZZZZ_.jpg\" />\n</a>\n", @target.get_tag(args("1234567890, rmwa-20, us"))
  end

end

