require 'rails_helper'

RSpec.describe "Articles", type: :request do
  let(:initial_attributes) do
    { title: 'test', body: 'test body'}
  end

  let(:valid_attributes) do
    { title: 'new test', body: 'new body' }
  end

  let(:nil_title_attributes) do
    { title: nil, body: 'new body' }
  end

  describe "GET :index" do
    before(:each) do 
      get articles_path
    end

    it 'returns with 200 success status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the :index view' do
      expect(response).to render_template(:index)
    end
  end

  describe "GET :new" do
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

  describe "POST :create" do
    context 'with valid parameters' do
      it 'returns with a 302 found status code' do
        post articles_path, params: { article: initial_attributes }

        expect(response).to have_http_status(:found)
      end

      it 'increases article count by 1' do
        expect {
          post articles_path, params: { article: valid_attributes } 
        }.to change {
          Article.count
        }.by(1)
      end

      it 'shows the latest article' do
        post(articles_path, params: { article: valid_attributes })

        expect(response).to redirect_to(article_path(Article.last)) 
      end 
    end

    context 'with invalid parameters' do
      it 'returns with a 422 status code' do
        post(articles_path, params: { article: nil_title_attributes })

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not increase article count' do
        expect {
          post(articles_path, params: { article: nil_title_attributes })
        }.to change {
          Article.count
        }.by(0)
      end

      it 'render the :new view' do
        post(articles_path, params: { article: nil_title_attributes })

        expect(response).to render_template(:new) 
      end
    end
  end

  describe "GET :show" do
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
        expect {
          get article_path(1)
        }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "GET :edit" do
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

  describe "POST :update" do
    context 'on update success' do
      let!(:article) { Article.create(initial_attributes) }

      before(:each) { put article_path(article, article: valid_attributes) }

      it 'returns 302 found status code' do
        expect(response).to have_http_status(:found)
      end

      it 'updates the article' do
        expect(article.reload.title).to eq(valid_attributes[:title])
        expect(article.reload.body).to eq(valid_attributes[:body])
      end

      it 'redirects to the updated article' do
        expect(response).to redirect_to(article_path(article))
      end
    end

    context 'on update failure' do
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

  describe "POST :delete" do
    let!(:article) { Article.create(initial_attributes) }

    context 'on delete success' do
      it 'returns with a 302 found response' do
        delete article_path(article)
        expect(response).to have_http_status(:found)
      end
    
      it 'changes Article.count by -1' do
        expect {
          delete article_path(article)
        }.to change {
          Article.count
        }.by(-1)
      end
    end
  end
end
