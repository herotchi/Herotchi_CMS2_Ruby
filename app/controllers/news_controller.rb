class NewsController < ApplicationController
  def index
    @news = News.released.page(params[:page]).per(NewsConstants::PAGENATE_LIST_LIMIT)
  end

  def show
  end
end
