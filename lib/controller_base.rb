require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './flash'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, params = {})
    @req = req
    @res = res
    @params = req.params.merge(params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    ensure_no_rerender

    res.status = 302
    res['Location'] = url

    save_cookies
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    ensure_no_rerender

    res.write(content)
    res['Content-Type'] = content_type

    save_cookies
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    directory = self.class.name.underscore
    filename = "views/#{directory}/#{template_name}.html.erb"

    erb = File.read(filename)
    html = ERB.new(erb).result(binding)

    render_content(html, "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)

    render name unless @already_built_response
  end

  private

  def ensure_no_rerender
    raise "double render" if already_built_response?
    @already_built_response = true
  end

  def save_cookies
    session.store(res)
    flash.store(res)
  end

end
