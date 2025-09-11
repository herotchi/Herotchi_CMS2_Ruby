class TopController < ApplicationController
  def index
    @news = News.top_news
    @carousels = Medium.carousels
    @pick_ups = Medium.pick_ups
  end
end
