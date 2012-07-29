#coding:UTF-8
require 'mechanize'
require 'webpage/common'
class Webpage
    def initialize(body,options={})
        raise ArgumentError 'body cannot be empty' unless body
        @body = body
        @options = options
        @body = @body.force_encoding(@options[:encoding]).encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "") if @options.has_key?:encoding
        @nokogiri = Nokogiri::HTML(@body)
    end

    def text
        return @nokogiri.xpath("//text()").text
        #return body.gsub(/<\/?[^>]*>/, "")
    end

    def keywords
        @keywords ||= @nokogiri.xpath("//meta[@name='keywords']").map{|meta|meta['content']}.flatten.join.split(',')
        #content = meta.attributes["content"].value unless meta.nil?
        #return content.split(',') unless content.nil?
    end
    
    def description
        @description ||= @nokogiri.xpath("//meta[@name='description']").map{|meta|meta['content']}.flatten.join
    end
    
    def links
        @links ||= %w(a area).map do |tag|
            @nokogiri.xpath("//#{tag}")
        end.flatten
    end
    def link_to?(target_uri)
        links.any?{|link|make_href_absolute(link['href']) == target_uri}
    end
    def link_to_host?(host)
        links.any?{|link|fuzzy_uri(link['uri'].to_s).host == host}
    end

    private
    def make_href_absolute(href)
        href = fuzzy_uri(href.to_s)
        return href.to_s if href.absolute?
        raise 'need :basepath in options when initialize' unless @options.has_key?:basepath
        basepath = fuzzy_uri(@options[:basepath])
        raise 'basepath should be absolute' unless basepath.absolute?
        URI.join(basepath,href)
    end
end
