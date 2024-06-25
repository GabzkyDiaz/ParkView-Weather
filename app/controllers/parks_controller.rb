class ParksController < ApplicationController
  def index
    if params[:search]
      @parks = Park.where('name LIKE ?', "%#{params[:search]}%").page(params[:page])
    else
      @parks = Park.page(params[:page])
    end
  end

  def show
    @park = Park.find(params[:id])
  end
end
