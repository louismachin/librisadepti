EN_DASH = '–'
CDN_BASE_URI = "https://cdn.louismachin.com/download/public/libris_adepti/works/"

class Work
    attr_reader :author, :title, :ext

    def initialize(file_name)
        puts "file_name=#{file_name}"
        @file_name = file_name
        @ext = File.extname(file_name)[1..-1]
        @file_name_no_ext = File.basename(file_name, ".*")
        # Parse filename
        @author, @title = @file_name_no_ext.split(" #{EN_DASH} ")
        # Caches
        @metadata = load_metadata(true)
        @open_library_search_cache = nil
        @open_library_cache = nil
    end

    def href
        CDN_BASE_URI + "#{@file_name}"
    end

    def load_metadata(debug_mode = false)
        default_data = {
            :title => @title,
            :author => [@author],
            :year => nil,
            :description => nil,
            :genres => [],
        }
        return default_data if debug_mode
        response = get_file(@file_name_no_ext + '.yml')
        if response == nil
            return default_data
            # TODO: Save this to the CDN
        else
            return YAML.load(response)
        end
    end

    def description
        return @metadata.dig('description')
    end

    def short_description
        desc = self.description
        return nil if desc == nil
        return desc unless desc.length > 100
        return desc[0, 200] + '...'
    end

    def genres
        return @metadata.dig('genres') || []
    end

    def formatted_author
        # TODO: Standardize author style
        return @author
    #   surname, forenames = @author.split(', ')
    #   return "#{forenames} #{surname}"
    end

    def open_library_search
        return @open_library_search_cache unless @open_library_search_cache == nil
        params = { :q => [@author, @title].join(' '), :sort => 'old' }
        uri = "https://openlibrary.org/search.json"
        response = simple_get_body(uri, params)
        @open_library_search_cache = response
        return response
    end

    def open_library
        return @open_library_cache unless @open_library_cache == nil
        search = open_library_search
    #   puts JSON.pretty_generate(search)
        return {} unless search.dig('numFound') > 0
        doc = search.dig('docs').first
        key = doc.dig('key')
        return {} unless key
        uri = "https://openlibrary.org#{key}.json"
        response = simple_get_body(uri)
        @open_library_cache = response
        return response
    end
end