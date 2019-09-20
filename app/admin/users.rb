ActiveAdmin.register User do
  config.batch_actions = false
  config.sort_order = 'created_at_desc'

  actions :index, :show, :edit, :update

  permit_params :email, :password, :password_confirmation

  filter :email_cont, label: 'Email'
  filter :created_at

  controller do
    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete('password')
        params[:user].delete('password_confirmation')
      end

      super
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :created_at
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      #f.input :image, image_preview: true
      #f.input :remove_image, as: :boolean if f.object.image.present?

      #f.globalize_inputs switch_locale: false do |t|
        #t.input :title
        #t.input :text, input_html: { class: 'editor' }
      #end
    end
    actions
  end
end
