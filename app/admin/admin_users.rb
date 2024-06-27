ActiveAdmin.register Park do
  permit_params :name, :location, images_attributes: [:id, :photo, :_destroy]

  index do
    selectable_column
    id_column
    column :name
    column :location
    column :created_at
    actions
  end

  filter :name
  filter :location
  filter :created_at

  form do |f|
    f.semantic_errors # This line is changed to handle errors correctly

    f.inputs 'Park Details' do
      f.input :name
      f.input :location
      # Add other inputs for park attributes as needed
    end

    f.inputs 'Images' do
      f.has_many :images, allow_destroy: true do |img_f|
        img_f.input :photo, as: :file, hint: img_f.object.photo.attached? ? image_tag(img_f.object.photo.variant(resize: "100x100")) : content_tag(:span, "No photo yet")
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row :name
      row :location
      # Add other rows for park attributes as needed

      row :images do |park|
        park.images.map do |image|
          image_tag(image.photo.variant(resize: "100x100")) if image.photo.attached?
        end.join(', ').html_safe
      end
    end
  end

  controller do
    def update
      if params[:park][:images_attributes]
        params[:park][:images_attributes].each do |key, value|
          if value[:_destroy] == "1" && !value[:id].blank?
            image = Image.find(value[:id])
            image.photo.purge
            image.destroy
          end
        end
      end
      super
    end
  end
end
