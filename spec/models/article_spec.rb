# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article do
  describe 'is valid when' do
    it 'title is present' do
      article = described_class.new(body: 'body')
      expect(article).not_to be_valid

      article.title = 'title'
      expect(article).to be_valid
    end

    it 'body is present' do
      article = described_class.new(title: 'title')
      expect(article).not_to be_valid

      article.body = 'body'
      expect(article).to be_valid
    end

    it 'title and body are present' do
      article = described_class.new(
        title: 'title',
        body: 'body'
      )
      expect(article).to be_valid
    end
  end
end
