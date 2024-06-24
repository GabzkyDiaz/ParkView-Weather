class ParksController < ApplicationController
  def index
    @parks = Park.page(params[:page])
  end

  def show
    @park = Park.find(params[:id])
  end
end
