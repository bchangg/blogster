class HealthController < ApplicationController
  def database
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection
    if ActiveRecord::Base.connected?
      render json: {
        success: true,
        name: ActiveRecord::Base.connection.current_database,
        message: 'Database connected'
      }, status: :ok
    else
      render json: {
        success: false,
        message: 'Not connected to database'
      }, status: :not_acceptable
    end
  rescue StandardError => e
    render json: {
      success: false,
      message: e
    }, status: :internal_server_error
  end
end
