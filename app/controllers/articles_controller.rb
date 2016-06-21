class ArticlesController < ApplicationController
  ### Convention order ==> Index, Show, New, Edit, Create, Update, Destroy
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    # @articles = Article.page(params[:page]).per(10)
    @q = Article.ransack(params[:q])
    # @articles = @q.result.includes(:genres, :users).page(params[:page]).per(10)
    @articles = @q.result
  end
  
  def show
  end

  def new
    @article = Article.new 
  end

  def edit
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      flash[:success] = "Article was successfully created."
      redirect_to article_path(@article)
    else
      render 'new'  ## render new article template in case of failure for another try
    end
  end

  def update
    if @article.update(article_params)
      flash[:success] = "Article was successfully updated."
      redirect_to article_path(@article)
    else
      render 'edit'  ## render edit article template in case of failure for another try
    end
  end

  def destroy
    @article.destroy
    flash[:danger] = "Article was successfully deleted."
    redirect_to articles_path
  end

  private
    def set_article  ## create private method to reuse
      @article = Article.find(params[:id])
    end
    def article_params  # whitelist method
      params.require(:article).permit(:title, :key, :youtube_url, :instrument, :description, genre_ids: [])
    end
    def require_same_user
      if (current_user != @article.user) and !current_user.admin?
        flash[:danger] = "You can only edit or delete your own articles"
        redirect_to root_path
      end
    end

end

