class ParksController < ApplicationController
  def index
    @activities = Activity.all
    search_query = params[:search].to_s.downcase

    @parks = Park.all

    if search_query.present?
      @parks = @parks.where('LOWER(name) LIKE ? OR LOWER(full_state_names) LIKE ?', "%#{search_query}%", "%#{search_query}%")
    end

    if params[:activity_id].present?
      @parks = @parks.joins(:activities).where('activities.id = ?', params[:activity_id])
    end

    @parks = @parks.page(params[:page])
  end

  def show
    @park = Park.find(params[:id])
  end
end
