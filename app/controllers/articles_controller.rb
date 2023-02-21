class ArticlesController < ApplicationController
  def index
    @limit = (params[:limit].nil? ? 10 : params[:limit]).to_i
    @page = (params[:page].nil? ? 1 : params[:page]).to_i

    @page_count = Article.count / @limit
    @page_count = 1 if @page_count.zero?

    @articles = Article.limit(@limit)
    @articles = @articles.offset(@page * @limit) if @page > 1
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
    @article = Article.find(params[:id])
  end

  def show
    @article = Article.find(params[:id])
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
end
