require 'uri'
require 'nokogiri'
def fuzzy_uri(uri)
    begin
        URI(uri).normalize
    rescue URI::InvalidURIError
        URI(URI.encode(uri)).normalize
    end
end
class URI::Generic
    def equal?(target)
        origin =  self.normalize.component_ary
        target = target.normalize.component_ary
        origin.pop
        target.pop
        return origin == target
    end
end

__END__
class Nokogiri::XML::Node
    def method_missing(name)
        p name
        return nil unless key?(name.to_s)
        get(name.to_s)
    end
end
class Mechanize::Page::Link
    def uri
        @uri ||= if @href then
            fuzzy_uri(@href)
        end
    end
end
