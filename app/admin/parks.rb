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
    f.semantic_errors
    f.inputs 'Park Details' do
      f.input :name
      f.input :location
    end

    f.inputs 'Images' do
      f.has_many :images, allow_destroy: true, new_record: true do |img_f|
        if img_f.object.persisted? && img_f.object.photo.attached?
          img_f.input :photo, as: :file, hint: image_tag(url_for(img_f.object.photo.variant(resize: "100x100")))
        else
          img_f.input :photo, as: :file, hint: content_tag(:span, "No photo yet")
        end
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :location
      row :images do |park|
        park.images.map do |image|
          image_tag(url_for(image.photo.variant(resize: "100x100"))) if image.photo.attached?
        end.join(', ').html_safe
      end
    end
  end

  controller do
    def update
      Rails.logger.debug("Update params: #{params.inspect}")

      # Custom logic for deleting images
      if params[:park][:images_attributes]
        params[:park][:images_attributes].each do |key, value|
          if value[:_destroy] == "1" && !value[:id].blank?
            begin
              image = Image.find(value[:id])
              image.photo.purge
              image.destroy
              params[:park][:images_attributes].delete(key)
            rescue ActiveRecord::RecordNotFound => e
              Rails.logger.error "Image with ID #{value[:id]} not found for Park with ID #{params[:id]}"
            end
          end
        end
      end

      # Find and update the park
      @park = Park.find(params[:id])
      if @park.update(permitted_params[:park])
        redirect_to admin_park_path(@park), notice: "Park was successfully updated."
      else
        render :edit
      end
    end
  end
end
