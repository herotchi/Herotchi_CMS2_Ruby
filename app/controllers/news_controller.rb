class NewsController < ApplicationController
  before_action :set_news, only: %i[ show ]

  def index
    @news = News.released.page(params[:page]).per(NewsConstants::PAGENATE_LIST_LIMIT)
  end

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news
      @news = News.released.find(params[:id])
    end
end
