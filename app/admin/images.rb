ActiveAdmin.register Image do
  permit_params :url, :source, :park_id, :photo

  index do
    selectable_column
    id_column
    column :url
    column :source
    column :park
    column :created_at
    actions
  end

  filter :url
  filter :source
  filter :park
  filter :created_at

  form do |f|
    f.semantic_errors
    f.inputs 'Image Details' do
      f.input :url
      f.input :source
      f.input :park
      f.input :photo, as: :file, hint: f.object.photo.attached? ? image_tag(f.object.photo.variant(resize: "100x100")) : content_tag(:span, "No photo yet")
    end
    f.actions
  end

  show do
    attributes_table do
      row :url
      row :source
      row :park
      row :photo do |image|
        image_tag(image.photo.variant(resize: "100x100")) if image.photo.attached?
      end
    end
  end
end
