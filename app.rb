require 'sinatra'
require 'redcarpet'

require_relative './models/environment'

APP_ROOT = File.expand_path(__dir__)

configure do
    set :bind, '0.0.0.0'
    set :port, $env.port
    set :public_folder, File.expand_path('public', __dir__)
    set :environment, :production if $env.is_production?
    disable :protection
end

require_relative './helpers/cdn'
require_relative './helpers/pagination'
require_relative './helpers/simple_web'

require_relative './models/copy'
require_relative './models/work'

require_relative './routes/index'