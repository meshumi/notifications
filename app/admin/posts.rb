ActiveAdmin.register Post, as: 'Posts' do
  config.batch_actions = false
  config.sort_order = 'created_at_desc'

  permit_params :created_at, :title, :message, :post_after_create, :domain_id, :posted

  filter :title, as: :string, label: 'Title'
  filter :created_at

  index pagination_total: false do
    selectable_column
    column :title
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :title
      row :message
      row :tag
      row :created_at
      row :post_after_create
    end
  end

  form do |f|
    f.inputs do
      domains = Domain.all.map { |e| [e.name, e.id] }
      selected = Domain.first
      f.input :domain_id, label: 'Domain',
              input_html: { class: 'form-dropdown' },
              as: :select,
              include_blank: false,
              collection: options_for_select(domains, selected)

      f.input :created_at, as: :date_time_picker, class: 'datetime-picker-input', value: Date.today

      f.input :title
      f.input :message
      f.input :post_after_create
      f.input :posted
    end
    actions
  end
end
