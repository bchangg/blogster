class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def create
    redirect_to articles_path
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end
end
