$cdn_work_list_cache = nil
$work_cache = nil

def get_list_of_works
    return $cdn_work_list_cache unless $cdn_work_list_cache == nil
    base_uri = 'https://cdn.louismachin.com'
    params = { api_key: $env.cdn_api_key }
    response = simple_get(base_uri + '/list/public/libris_adepti/works', params)
    if response.code == '200'
        body = JSON.parse(response.body)
        file_list = body.dig('files')
        file_list.select! { |file_path| File.extname(file_path) == '.pdf' }
        $cdn_work_list_cache = file_list
        return file_list
    else
        return []
    end
end

def get_works
    return $work_cache unless $work_cache == nil
    result = []
    for file_name in get_list_of_works do
        work = Work.new(file_name)
        puts "author=#{work.author}\ntitle=#{work.title}\next=#{work.ext}"
        puts "description=#{work.description}"
        result << work
    end
    $work_cache = result
    return result
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