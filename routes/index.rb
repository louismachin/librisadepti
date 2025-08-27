get '/' do
    puts palette
    @copy = $default_copy
    @weather = get_weather(get_ip)
    @thelemic_date = get_thelemic_date
    @work_count, @work_size = get_work_stats
    erb :home, locals: {
        copy: @copy,
        work_count: @work_count, work_size: @work_size,
        weather: @weather, thelemic_date: @thelemic_date,
    }
end

not_found do
    @copy = $default_copy
    status 404
    erb :not_found
end