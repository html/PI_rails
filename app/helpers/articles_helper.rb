module ArticlesHelper
  B = { :controller => :articles }
  def articles_path
    url_for(B)
  end

  def new_article_path
    url_for(B.merge(:action => :new))
  end

  def create_article_path
    url_for(B.merge(:action => :create))
  end

  def article_path(article)
    url_for(B.merge(:action => :show, :id => article.to_param))
  end

  def edit_article_path(article)

    url_for(B.merge(:action => :edit, :id => article.to_param))
  end
end
