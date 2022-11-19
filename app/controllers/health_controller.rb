class HealthController < ApplicationController
  def database
    begin
      ActiveRecord::Base.establish_connection
      ActiveRecord::Base.connection
      if ActiveRecord::Base.connected?
        render json: {
          success: true,
          message: 'Database connected'
        }
      else
        render json: {
          success: false,
          message: 'Not connected to database'
        }
      end
    rescue => e
      render json: {
        success: false,
        message: e
      }
    end
  end
end
