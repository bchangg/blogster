# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Health' do
  describe 'GET :database' do
    it 'returns with 200 success status code' do
      get health_path

      expect(response).to have_http_status(:ok)
    end
  end
end
