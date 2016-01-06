require 'json'

class Flash
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @req = req

    if req.cookies['_rails_lite_app_flash']
      @flash_now_hash = JSON.parse(req.cookies['_rails_lite_app_flash'])
    else
      @flash_now_hash = {}
    end
    @flash_hash = {}
  end

  def [](key)
    @flash_hash.merge(@flash_now_hash)[key]
  end

  def to_hash
    @flash_hash.merge(@flash_now_hash)
  end

  def []=(key, val)
    @flash_hash[key] = val
  end

  def now
    @flash_now_hash
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store(res)
    hash_json = @flash_hash.to_json
    cookie = {value: hash_json, path: '/'}
    res.set_cookie('_rails_lite_app_flash', cookie)
  end
end
