class Flash
  attr_reader :now

  def initialze(req)
    if req.cookies['_mvc_otr_flash']
      cookie = JSON.parse(req.cookies['_mvc_otr_flash'])
    else
      cookie = {}
    end
    @now_flash = FlashStore.new(cookie)
    @regular_flash = FlashStore.new
  end

  def [](key)
    @regular_flash[key] || @now_flash[key]
  end

  def []=(key, val)
    @regular_flash[key] = val
  end

  def store_flash(res)
    res.set_cookie('_mvc_otr_flash', { path: '/', value: @regular_flash.to_json })
  end

end

class FlashStore
  def initialize(cookie = {})
    @cookie = cookie
  end

  def [](key)
    val = @cookie[key.to_s]

    if val.is_a?(String) && val.start_with?("__SYM__")
      return val.slice(7, val.length).to_sym
    end

    val
  end

  def []=(key, val)
    val = "__SYM__" + val.to_s if val.is_a?(Symbol)
    @store[key.to_s] = val
  end

  def to_json
    @cookie.to_json
  end
end
