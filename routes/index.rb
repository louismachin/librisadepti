get '/' do
    @copy = $default_copy
    @weather = get_weather(get_ip)
    @thelemic_date = get_thelemic_date
    erb :home, locals: {
        copy: @copy, weather: @weather, thelemic_date: @thelemic_date
    }
end

not_found do
    @copy = $default_copy
    status 404
    erb :not_found
end