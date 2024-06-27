ActiveAdmin.register Weather do
  permit_params :temperature, :conditions, :date, :forecast, :park_id

  index do
    selectable_column
    id_column
    column :temperature
    column :conditions
    column :date
    column :forecast
    column :park
    column :created_at
    actions
  end

  filter :temperature
  filter :conditions
  filter :date
  filter :forecast
  filter :park
  filter :created_at

  form do |f|
    f.semantic_errors
    f.inputs 'Weather Details' do
      f.input :temperature
      f.input :conditions
      f.input :date
      f.input :forecast
      f.input :park
    end
    f.actions
  end
end
