Rack::Attack.throttle("graphql requests by ip", limit: 5000, period: 3600) do |request|
  request.ip
end
