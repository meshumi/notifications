ActiveAdmin.register NotificationReceiver, as: 'NotificationReceiver' do
  config.batch_actions = true
  config.sort_order = 'created_at_desc'
  actions :index, :edit, :update, :new, :create

  permit_params :p256dh, :auth, :created_at, :endpoint, :domain_id

  filter :domain_id, label: 'Domain'

  index pagination_total: false do
    selectable_column
    column :domain_id
    actions
  end

  show do
    attributes_table do
      row :p256dh
      row :auth
      row :endpoint
      row :domain_id
    end
  end

  form do |f|
    domains = Domain.all.map { |e| [e.name, e.id] }
    selected = Domain.first
    f.inputs do
      f.input :domain_id, label: 'Domain',
              input_html: { class: 'form-dropdown' },
              as: :select,
              include_blank: false,
              collection: options_for_select(domains, selected)
      f.input :p256dh
      f.input :auth
      f.input :endpoint
    end
    actions
  end
end
