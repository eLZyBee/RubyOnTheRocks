require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, params = {})
    @req, @res, @params = req, res, req.params.merge(params)
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise 'hell' if already_built_response?
    res['Location'] = url
    res.status = 302
    session.store_session(res)
    res.finish
    @already_built_response = true
  end

  def render_content(content, content_type)
    raise 'hell' if already_built_response?
    res['Content-Type'] = content_type
    res.write(content)
    session.store_session(res)
    res.finish
    @already_built_response = true
  end

  def render(template_name)
    file_content = File.read("views/#{self.class.to_s.underscore}/#{template_name.to_s}.html.erb")
    content = ERB.new(file_content).result(binding)
    render_content(content, 'text/html')
  end

  def session
    @session ||= Session.new(req)
  end

  def invoke_action(name)
    send(name) unless already_built_response?
  end
end
