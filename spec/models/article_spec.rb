require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'is valid when' do
    it 'title is present' do
      article = Article.new(body: 'body')
      expect(article).to_not be_valid

      article.title = 'title'
      expect(article).to be_valid
    end

    it 'body is present' do
      article = Article.new(title: 'title')
      expect(article).to_not be_valid

      article.body = 'body'
      expect(article).to be_valid
    end

    it 'title and body are present' do
      article = Article.new(
        title: 'title',
        body: 'body'
      )
      expect(article).to be_valid
    end
  end
end
