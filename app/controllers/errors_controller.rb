class ErrorsController < ApplicationController
  rescue_from StandardError, with: :render_500
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  # envより受け取った例外を再度raiseして振り分ける
  def show
    exception = request.env["action_dispatch.exception"]
    raise exception
  end

  def render_404(exception = nil)
    logger.info "Rendering 404 with exception: #{exception.message}" if exception
    render "errors/404", status: :not_found
  end

  def render_500(exception = nil)
    logger.info "Rendering 500 with exception: #{exception.message}" if exception
    render "errors/500", status: :internal_server_error
  end
end
