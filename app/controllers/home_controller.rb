class HomeController < ApplicationController
  layout "homepage", only: [:index]

  def index
  end
end
