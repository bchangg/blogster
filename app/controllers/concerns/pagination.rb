# frozen_string_literal: true

module Pagination
  def self.paginate(collection:, params: {})
    pagination = PaginationService.new(collection, params)

    [
      pagination.metadata,
      pagination.results
    ]
  end
end
