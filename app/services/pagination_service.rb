# frozen_string_literal: true

class PaginationService
  attr_reader :collection, :params

  def initialize(collection, params = {})
    @collection = collection
    @params = params.merge(count: collection.count)
  end

  def metadata
    @metadata ||= PaginationViewModel.new(params)
  end

  def results
    collection
      .limit(metadata.per_page)
      .offset(metadata.offset)
  end
end
