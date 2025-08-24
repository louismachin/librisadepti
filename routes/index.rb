get '/' do
    @copy = $default_copy
    erb :home, locals: { copy: @copy }
end

get '/works' do
    @copy = $default_copy
    @page_no = params[:p] ? params[:p].to_i : 1
    @works, @page_count = get_page(get_works, @page_no)
    erb :works, locals: { copy: @copy, works: @works }
end

not_found do
    @copy = $default_copy
    status 404
    erb :not_found
end