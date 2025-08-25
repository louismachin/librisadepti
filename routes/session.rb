BAD_IPS = ['::ffff:127.0.0.1', '::1', '127.0.0.1']

helpers do
  def get_ip
    request.env['HTTP_X_FORWARDED_FOR'] || 
    request.env['HTTP_X_REAL_IP'] || 
    request.ip
  end
end