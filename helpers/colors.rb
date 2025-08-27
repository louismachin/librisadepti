helpers do
    def palette
        color_scheme = request.env['HTTP_SEC_CH_PREFERS_COLOR_SCHEME']
        if color_scheme == 'light'
            return 'light'
        else
            return 'dark'
        end
    end
end