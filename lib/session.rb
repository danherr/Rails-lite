require 'json'
require 'byebug'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @req = req

    if req.cookies['_rails_lite_app']
      @session_hash = JSON.parse(req.cookies['_rails_lite_app'])
    else
      @session_hash = {}
    end
  end

  def [](key)
    @session_hash[key]
  end

  def []=(key, val)
    @session_hash[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    hash_json = @session_hash.to_json
    cookie = {value: hash_json, path: '/'}
    res.set_cookie('_rails_lite_app', cookie)
  end
end
