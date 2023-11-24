# frozen_string_literal: true

class ArticlesController < ApplicationController
  def index
    @pagination, @articles = Pagination.paginate(collection: Article, params: page_params)
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    article = Article.find(params[:id])

    if article.destroy
      flash[:notice] = "#{article.title} was deleted"
    else
      flash[:alert] = "Could not delete #{article.title}"
    end
    redirect_to articles_path
  end

  private

  def article_params
    params.require(:article).permit(:title, :body)
  end

  def page_params
    params.permit(:page, :per_page)
  end
end
