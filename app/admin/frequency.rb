ActiveAdmin.register Frequency, as: 'Frequency' do
  config.batch_actions = false
  config.sort_order = 'created_at_desc'

  permit_params :period, :domain_id

  filter :period
  filter :domain

  index pagination_total: false do
    selectable_column
    column :period
    column :domain
    actions
  end

  show do
    attributes_table do
      row :period
    end
  end

  form do |f|
    domains = Domain.all.map { |e| [e.name, e.id] }
    selected = Domain.first
    f.inputs do
      f.input :period, include_blank: false
      f.input :domain_id, label: 'Domain',
              input_html: { class: 'form-dropdown' },
              as: :select,
              include_blank: false,
              collection: options_for_select(domains, selected)

      f.input :starting_at, as: :date_time_picker, class: 'datetime-picker-input', value: Date.today.strftime('%d/%m/%Y')
      f.input :start_posting, as: :boolean, label: 'Posting started?'
    end
    actions
  end
end
