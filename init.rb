# vim: set ts=2 sts=2 sw=2 expandtab :
require 'redmine'

class AmazonUrlBuilderDefault
  attr_accessor :url 

  def item(asin)
    @url = "#"
    self
  end

  def image(asin)
    @url = "#"
    self
  end

  def associate(associate_id)
    self
  end
end


class AmazonUrlBuilderJp
  attr_accessor :url 

  def item(asin)
    # refer: http://chalow.net/2009-01-13-4.html
    @url = "http://amazon.jp/o/ASIN/#{asin}"
    self
  end

  def image(asin)
    # refer: http://aaugh.com/imageabuse.html 
    @url = "http://ec3.images-amazon.com/images/P/#{asin}.09._PC_SCMZZZZZZZ_.jpg"
    self
  end

  # returns str1 basically.
  # sometimes returns str2.
  # (chance of str2 selection is about once over ten times)
  def random_select(str1, str2)
    return str1 if rand(10) != 0
    return str2
  end

  def associate(associate_id)
    @url = "#{@url}/#{random_select(associate_id,"rmw-22")}" unless associate_id == nil
    self
  end
end



class AmazonHelper
  def builder(country)
    case country
    when :jp then AmazonUrlBuilderJp.new
    else AmazonUrlBuilderDefault.new
    end
  end

  def trim(str)
    return str.strip unless str == nil
    return nil
  end


  def parse_args(args)
    asin = trim(args[0])
    associate_id = trim(args[1])
    country = (trim(args[2]).intern unless args[2] == nil) || :jp

    return asin, associate_id, country
  end


  def get_image_url(asin, country)
    builder(country).image(asin).url
  end


  def get_item_url(asin, associate_id, country)
    builder(country).item(asin).associate(associate_id).url
  end


  def get_tag(args)
    return "(No parameters specified. ASIN is needed at least)" if args.empty?
    asin, associate_id, country = parse_args(args)

    return <<TEMPLATE
<a href="#{get_item_url(asin, associate_id, country)}">
  <img src="#{get_image_url(asin, country)}" />
</a>
TEMPLATE
  end

end


Redmine::Plugin.register :redmine_wiki_amazon do
  name 'Redmine Plugin Amazon Link Wiki Macro'
  author 'Takashi Oguma'
  description 'This plugin provides a macro \'amazon\' for Wiki which enables you to embed images and links to Amazon product page.'
  version '0.0.1'

  Redmine::WikiFormatting::Macros.register do
    desc "make a link to Amazon product page.\n"
    macro :amazon do |obj, args|
      h = AmazonHelper.new
      h.get_tag(args)
    end

  end

end
