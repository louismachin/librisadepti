get '/' do
    @copy = $default_copy
    @weather = get_weather(get_ip)
    @thelemic_date = get_thelemic_date
    erb :home, locals: {
        copy: @copy, weather: @weather, thelemic_date: @thelemic_date
    }
end

get '/works' do
    @copy = $default_copy
    @works = get_works
    @page_no = params[:p] ? params[:p].to_i : 1
    # Filter by author
    @author = params[:author].nil? ? nil : params[:author]
    puts "author=#{@author}"
    @works.select! { |work| work.author == @author } if @author
    # Paginate
    @works, @page_count = get_page(@works, @page_no)
    # Render
    locals = { copy: @copy, works: @works }
    locals[:author] = @author unless @author.nil?
    erb :works, locals: locals
end

get '/authors' do
    @copy = $default_copy
    @authors_by_initial = get_authors_by_initial
    erb :authors, locals: {
        copy: @copy, authors_by_initial: @authors_by_initial
    }
end

not_found do
    @copy = $default_copy
    status 404
    erb :not_found
end