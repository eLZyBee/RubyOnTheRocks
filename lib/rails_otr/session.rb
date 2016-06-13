require 'byebug'
require 'json'

class Session

  def initialize(req)
    if req.cookies['_rails_otr']
      @session_cookie = JSON.parse(req.cookies['_rails_otr'])
    else
      @session_cookie = {}
    end
  end

  def [](key)
    @session_cookie[key]
  end

  def []=(key, val)
    @session_cookie[key] = val
  end


  def store_session(res)
    res.set_cookie('_rails_otr', { path: '/', value: @session_cookie.to_json })
  end
end
