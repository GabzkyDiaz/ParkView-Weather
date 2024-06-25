class ParksController < ApplicationController
  def index
    @activities = Activity.all
    if params[:search] && params[:activity_id]
      @parks = Park.joins(:activities).where('parks.name LIKE ? AND activities.id = ?', "%#{params[:search]}%", params[:activity_id]).page(params[:page])
    elsif params[:search]
      @parks = Park.where('name LIKE ?', "%#{params[:search]}%").page(params[:page])
    elsif params[:activity_id]
      @parks = Park.joins(:activities).where('activities.id = ?', params[:activity_id]).page(params[:page])
    else
      @parks = Park.page(params[:page])
    end
  end

  def show
    @park = Park.find(params[:id])
  end
end
