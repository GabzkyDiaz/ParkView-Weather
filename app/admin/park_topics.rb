ActiveAdmin.register ParkTopic do
  permit_params :topic_id, :park_id

  index do
    selectable_column
    id_column
    column :topic
    column :park
    column :created_at
    actions
  end

  filter :topic
  filter :park
  filter :created_at

  form do |f|
    f.semantic_errors
    f.inputs 'ParkTopic Details' do
      f.input :topic
      f.input :park
    end
    f.actions
  end
end
