class Article < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true

  before_save :set_slug

  def to_param
    return nil unless persisted?

    [id, slug].join('-')
  end

  def set_slug
    self.slug = title.parameterize
  end
end
