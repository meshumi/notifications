ActiveAdmin.register Domain, as: 'Domains' do
  config.batch_actions = false
  config.sort_order = 'created_at_desc'

  permit_params :name

  filter :name
  filter :created_at

  index pagination_total: false do
    selectable_column
    column :name
    actions
  end

  show do
    attributes_table do
      row :name
    end
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    actions
  end
end
