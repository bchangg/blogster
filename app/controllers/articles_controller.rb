class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
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

  private
  def article_params
    params.require(:article).permit(:title, :body)
  end
end
