#coding:UTF-8
require 'webpage'
sample = File.read(File.join(File.dirname(__FILE__),'sample'))
sample_uri = 'http://www.hudong.com/wiki/甜菜根'
sample_to_uri = 'http://123.hudong.com/'
sample_not_to_uri = 'http://1234.hudong.com/'
sample_to_host = 'hudong.com'
sample_title = '甜菜根_互动百科'
sample_h1 = '甜菜根'
sample_keywords = '甜菜根,,健康,植物,自然'.split(',')
sample_description = '甜菜根-甜菜根，也叫作根菾菜、红菜头，亦有称“红甜菜”的，但与红甜菜实为不同变种。研究发现它可以帮助肌肉利用氧气，效果约提升3%，持续30分钟，可能成为运动员的秘密武器。-tiancaigen'
page = Webpage.new(sample,{:uri=>sample_uri,:domain=>'hudong.com'})
describe URI::Generic do
    it "" do
    URI('http://host1.abc.com/a/b/c?d=e&f=g#frag').should be_equal URI('http://host1.abc.com/a/b/c?d=e&f=g#frag')
    URI('http://host1.abc.com/a/b/c?d=e&f=g#frag').should_not be_equal URI('http://host1.abc.com/a/b/c?f=g&d=e#frag')
    end
end
describe Webpage do
    it "title should be String" do
        page.title.class.should == String
    end

    it "text should be String" do
        page.text.class.should == String
    end

    it "links should be an array" do
        page.links.class.should == Array
    end

    it "[] should return class Nokogiri::XML::NodeSet" do
        %w(canonical keywords description).each do |tag|
            page[tag].class.should == Nokogiri::XML::NodeSet
        end
    end

    it "nodes_with should return an array with elements Nokogiri::XML::NodeSet" do
        page.nodes_with('id').class.should == Nokogiri::XML::NodeSet
    end
    it "links' elements should be Webpage::Link" do
        page.links.each do |link|
            link.class.should == Nokogiri::XML::Element
        end
    end

    it "description should be text" do
        page.description.class.should == String
    end
    
    it "keywords should be array" do
        page.keywords.class.should == Array
    end

    it "keywords's values should be strings" do
        page.keywords.each do |keyword|
            keyword.class.should == String
        end
    end
    
    it "link_to? should return bool" do
        [TrueClass,FalseClass].should include page.link_to?(sample_to_uri).class
    end

    it "link_to_host? should return bool" do
        [TrueClass,FalseClass].should include page.link_to_host?(sample_to_host).class
    end

    it "links_to_different_domain should return Array" do
        page.links_to_different_domain.class.should == Array
    end

    it "links_to_different_host should return Array" do
        page.links_to_different_host.class.should == Array
    end
end

describe "the instance webpage of #{sample_uri}" do
    it "title should be #{sample_title}" do
        page.title.should == sample_title
    end
    it "text should be big enought" do
        page.text.size.should > 500
    end
    it "should has correct description " do
        page.description.should == sample_description
    end
    it "should has #{sample_keywords.size} keywords" do
        page.keywords.size.should == sample_keywords.size
    end
    it "should has 40 nodes with property 'id'"do
        page.nodes_with('id').size.should == 92
    end
    it "should has <h1>#{sample_h1}"do
        page['h1'].text.should == sample_h1
    end
    it "should has canonical to #{sample_uri}" do
        page.canonical.should == sample_uri
    end

    it "should link_to #{sample_to_uri}" do
        page.link_to?(sample_to_uri).should be_true
    end

    it "should not link_to #{sample_not_to_uri}" do
        page.link_to?(sample_not_to_uri).should be_false
    end
    
    it "should has link to " do
        page.links_to_different_host.any?{|link|link['href']}
    end
    it "should has link to" do
        page.links_to_different_domain
    end
end
