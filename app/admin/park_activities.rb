ActiveAdmin.register ParkActivity do
  permit_params :activity_id, :park_id

  index do
    selectable_column
    id_column
    column :activity
    column :park
    column :created_at
    actions
  end

  filter :activity
  filter :park
  filter :created_at

  form do |f|
    f.semantic_errors
    f.inputs 'ParkActivity Details' do
      f.input :activity
      f.input :park
    end
    f.actions
  end
end
