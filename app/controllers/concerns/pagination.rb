# frozen_string_literal: true

require_relative '../../services/pagination'

module Pagination
  def self.paginate(collection:, params: {})
    pagination = Services::Pagination.new(collection, params)

    [
      pagination.metadata,
      pagination.results
    ]
  end
end
