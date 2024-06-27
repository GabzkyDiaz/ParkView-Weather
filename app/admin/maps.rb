ActiveAdmin.register Map do
  permit_params :map_url, :latitude, :longitude, :park_id

  index do
    selectable_column
    id_column
    column :map_url
    column :latitude
    column :longitude
    column :park
    column :created_at
    actions
  end

  filter :map_url
  filter :latitude
  filter :longitude
  filter :park
  filter :created_at

  form do |f|
    f.semantic_errors
    f.inputs 'Map Details' do
      f.input :map_url
      f.input :latitude
      f.input :longitude
      f.input :park
    end
    f.actions
  end
end
