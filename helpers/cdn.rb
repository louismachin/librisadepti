$cdn_work_list_cache = nil
$work_cache = nil
$work_size_cache = nil

def format_bytes(bytes)
    units = %w[B KB MB GB TB]
    i = 0
    while bytes >= 1024 && i < units.length - 1
        bytes /= 1024.0
        i += 1
    end
    precision = case units[i]
        when "B", "KB" then 0
        when "MB" then 1
        when "GB", "TB" then 2
        else 0
    end
    format("%.#{precision}f%s", bytes, units[i])
end

def get_list_of_works
    return $cdn_work_list_cache unless $cdn_work_list_cache == nil
    base_uri = 'https://cdn.louismachin.com'
    params = { api_key: $env.cdn_api_key }
    response = simple_get(base_uri + '/list/public/libris_adepti/works', params)
    if response.code == '200'
        body = JSON.parse(response.body)
        $work_size_cache = body['size']
        file_list = body.dig('files')
        file_list.select! { |file_path| File.extname(file_path) == '.pdf' }
        $cdn_work_list_cache = file_list
        return file_list
    else
        return []
    end
end

def get_works
    return $work_cache.clone unless $work_cache == nil
    result = []
    for file_name in get_list_of_works do
        work = Work.new(file_name)
    #   puts "author=#{work.author}\ntitle=#{work.title}\next=#{work.ext}"
    #   puts "description=#{work.description}"
        result << work
    end
    $work_cache = result
    return result.clone
end

def get_work_size
    $work_size_cache ? format_bytes($work_size_cache) : '???'
end

def get_work_stats
    return [
        get_works.length,
        get_work_size,
    ]
end

def get_file(file_name)
    base_uri = 'https://cdn.louismachin.com'
    params = { api_key: $env.cdn_api_key }
    file_name = URI.encode_www_form_component(file_name)
    uri = base_uri + '/download/public/libris_adepti/works/' + file_name
    response = simple_get(uri, params)
    if response.code == '200'
        body = response.body
        return body
    else
        return nil
    end
end

def get_authors
    get_works.map { |work| work.author }.uniq
end

def get_authors_by_initial
    authors = get_authors
    initials = authors.map { |author| author[0] }.uniq.sort
    result = {}
    initials.each { |initial| result[initial] = [] }
    authors.each { |author| result[author[0]] << author }
    return result
end