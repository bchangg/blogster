# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Articles' do
  let(:initial_attributes) do
    attributes_for(:article)
  end

  let(:valid_attributes) do
    attributes_for(:article)
  end

  let(:nil_title_attributes) do
    attributes_for(:article, body: nil)
  end

  describe 'GET :index' do
    before(:each) do
      get articles_path
    end

    it 'returns with 200 success status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the :index view' do
      expect(response).to render_template(:index)
    end

    it 'assigns @pagination, @articles' do
      expect(assigns(:pagination)).to be_a PaginationViewModel
      expect(assigns(:articles)).to be_a ActiveRecord::Relation
    end

    context 'when given different query params' do
      before do
        create_list(:article, 50)
      end

      [
        { per_page: 5, expected: 10 },
        { per_page: 30, expected: 2 },
        { per_page: 50, expected: 1 }
      ].each do |params|
        it 'dynamically assigns @pagination.total_pages' do
          get articles_path, params: { per_page: params[:per_page] }
          expect(assigns(:pagination).total_pages).to eq(params[:expected])
        end
      end

      [
        { page: 1, per_page: 5, expected: 0 },
        { page: 2, per_page: 5,  expected: 5 },
        { page: 3, per_page: 10, expected: 20 }
      ].each do |params|
        it 'dynamically assigns @pagination.offset' do
          get articles_path, params: {
            page: params[:page],
            per_page: params[:per_page]
          }
          expect(assigns(:pagination).offset).to eq(params[:expected])
        end
      end

      [
        { page: 1, expected: nil },
        { page: 2, expected: 1 }
      ].each do |params|
        it 'dynamically assigns @pagination.previous_page' do
          get articles_path, params: { page: params[:page] }
          expect(assigns(:pagination).previous_page).to eq(params[:expected])
        end
      end

      [
        { page: 1, expected: true },
        { page: 2, expected: false },
        { page: 3, expected: false }
      ].each do |params|
        it 'dynamically assigns @pagination.first_page?' do
          get articles_path, params: { page: params[:page] }
          expect(assigns(:pagination).first_page?).to eq(params[:expected])
        end
      end
    end
  end

  describe 'GET :new' do
    before(:each) do
      get new_article_path
    end

    it 'returns with 200 success status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the :new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST :create' do
    context 'with valid parameters' do
      it 'increases article count by 1' do
        expect { post articles_path, params: { article: valid_attributes } }
          .to change(Article, :count)
          .by(1)
      end

      it 'redirects to the latest article' do
        post(articles_path, params: { article: valid_attributes })

        expect(response).to redirect_to(article_path(Article.last))
      end
    end

    context 'with invalid parameters' do
      it 'returns with a 422 status code' do
        post articles_path(article: nil_title_attributes)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not increase article count' do
        expect { post articles_path(article: nil_title_attributes) }
          .not_to change(Article, :count)
      end

      it 'render the :new view' do
        post articles_path(article: nil_title_attributes)

        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET :show' do
    context 'with valid id' do
      before(:each) do
        article = Article.create(initial_attributes)

        get article_path(article)
      end

      it 'returns with a 200 success status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the :show view when given a valid id' do
        expect(response).to render_template(:show)
      end
    end

    context 'with invalid id' do
      it 'raise ActiveRecord::RecordNotFound error' do
        expect { get article_path(1) }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    context 'with no id' do
      it 'raise ActionController::UrlGenerationError error' do
        expect { get article_path }.to raise_exception(ActionController::UrlGenerationError)
      end
    end
  end

  describe 'GET :edit' do
    let!(:article) { Article.create(initial_attributes) }

    before(:each) { get edit_article_path(article) }

    it 'returns with a 200 success status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the edit template with article information' do
      expect(response.body).to include(article.title)
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST :update' do
    context 'when update succeeds' do
      let!(:article) { Article.create(initial_attributes) }

      before(:each) { put article_path(article, article: valid_attributes) }

      it 'redirects to the updated article' do
        expect(response).to redirect_to(article_path(article.reload))
      end

      it 'updates the article' do
        expect(article.reload.title).to eq(valid_attributes[:title])
        expect(article.reload.body).to eq(valid_attributes[:body])
      end
    end

    context 'when update fails' do
      let!(:article) { Article.create(initial_attributes) }

      it 'returns with a 422 unprocessable entity error' do
        put article_path(article, article: nil_title_attributes)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not update article' do
        put article_path(article, article: nil_title_attributes)
        expect(article.reload.title).to eq(initial_attributes[:title])
        expect(article.reload.body).to eq(initial_attributes[:body])
      end
    end
  end

  describe 'POST :delete' do
    subject(:delete_request) { delete article_path(article) }

    let!(:article) { Article.create(initial_attributes) }

    context 'when delete succeeds' do
      it 'redirects to the articles index page' do
        delete_request
        expect(response).to redirect_to(articles_path)
      end

      it 'changes Article.count by -1' do
        expect { delete_request }.to change(Article, :count).by(-1)
      end

      it 'flashes a success message' do
        delete_request

        expect(flash[:notice]).not_to be_nil
      end
    end

    context 'when delete fails' do
      before do
        allow(Article).to receive(:find).and_return(article)
        allow(article).to receive(:destroy).and_return(false)
      end

      it 'flashes a failure message' do
        delete_request

        expect(flash[:alert]).not_to be_nil
      end
    end
  end
end
