require 'rack'

da_app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  res['Content-Type'] = 'text/html'
  body = req.path
  res.write(body)
  res.finish
end

Rack::Server.start(
  app: da_app,
  Port: 3000
)
