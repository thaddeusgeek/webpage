#coding:UTF-8
require 'webpage'
uri = 'http://www.hudong.com/'
to_uri = 'http://123.hudong.com/'
to_host = 'hudong.com'
page = Mechanize.new.get uri
page = Webpage.new(page.body,{:basepath=>uri})
describe Webpage do
    it "text should be String" do
        page.text.class.should == String
    end

    it "links should be an array" do
        page.links.class.should == Array
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
        [TrueClass,FalseClass].should include page.link_to?(to_uri).class
    end

    it "link_to_host? should return bool" do
        [TrueClass,FalseClass].should include page.link_to_host?(to_host).class
    end
end

describe "the instance webpage" do
    it "text should be big enought" do
        page.text.size.should > 500
    end
    it "should has correct description " do
        page.description.should == '互动百科是基于中文维基技术(维客,wiki百科)的网络百科全书,是全球最大中文百科网及百科全书。互动百科中文网,助您轻松百科探秘'
    end
    it "should has 7 keywords" do
        page.keywords.size.should == 9
    end

    it "should link_to #{to_uri}" do
        page.link_to?(to_uri).should be_true
    end
end
