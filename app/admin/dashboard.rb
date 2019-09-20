# frozen_string_literal: true
ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  controller do
    # after_action :skip_authorization
  end

  # action_item only: :index do
  #   link_to 'Create new Post', new_admin_post_path
  # end

  # content title: 'Dashboard' do
    # panel 'The recent published posts' do
    #   # table_for Post.order(created_at: :desc).limit(10) do
    #   #   column('State') { |post| status_tag(post.current_state, status_tag_color_by_state(post.current_state)) }
    #   #   column('Date') { |post| l(post.created_at, format: :long) }
    #   #   column('Title') { |post| link_to(post.decorate.safe_title, admin_post_path(post)) }
    #   # end
    # end

    # columns do
    #   column do
    #     panel '50 most used tags' do
    #       table_for ActsAsTaggableOn::Tag.most_used(50) do
    #         column('Name', &:name)
    #         column('Count', &:taggings_count)
    #       end
    #     end
    #   end
    #
    #   column do
    #     panel '50 least used tags' do
    #       table_for ActsAsTaggableOn::Tag.least_used(50) do
    #         column('Name', &:name)
    #         column('Count', &:taggings_count)
    #       end
    #     end
    #   end
    # end
  # end
end
