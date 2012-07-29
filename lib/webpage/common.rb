def fuzzy_uri(uri)
    begin
        URI(uri).normalize
    rescue URI::InvalidURIError
        URI(URI.encode(uri)).normalize
    end
end
class Mechanize::Page::Link
    def uri
        @uri ||= if @href then
            fuzzy_uri(@href)
        end
    end
end
