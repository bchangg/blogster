module ApplicationHelper
  def path_with_params(path, params)
    "#{path}?#{params.to_query}"
  end
end
