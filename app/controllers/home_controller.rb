class HomeController < ApplicationController
  def hello_world
    render json: {
      success: true,
      message: 'hello world'
    }
  end
end