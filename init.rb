require 'redmine'

class AmazonHelper
  def initialize
  end


  def get_image_url(asin)
    # refer: http://aaugh.com/imageabuse.html 
    return "http://ec3.images-amazon.com/images/P/#{asin}.09._PC_SCMZZZZZZZ_.jpg"
  end


  def get_url(asin)
    base_url = 'http://amazon.jp/o/ASIN/'
    return base_url + asin
  end


  def get_tag(asin)
    return @template = <<EOD
<a href="#{get_url(asin)}">
  <img src="#{get_image_url(asin)}" />
</a>
EOD
  end

end


Redmine::Plugin.register :redmine_wiki_amazon do
  name 'Redmine Wiki Amazon plugin'
  author 'Takashi Oguma'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  
  Redmine::WikiFormatting::Macros.register do
    desc "make a link to Amazon product page.\n"
    macro :amazon do |obj, args|
      h = AmazonHelper.new
      return h.get_tag(args[0]) unless args.empty?
    end

  end

end
