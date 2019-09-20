lock '3.11.1'

# set :rvm_type, :system
set :rvm_ruby_version, '2.6.4'

set :application, 'notifications'
set :repo_url, 'ssh://git@github.com:meshumi/notifications.git'

set :deploy_to, '/home/www/notifications'
set :deploy_user, 'deployer'
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :keep_releases, 5

set :pty, false
set :use_sudo, false
set :stage, :production
set :deploy_via, :remote_cache

set :disallow_pushing, true
set :compressor, :bzip2
set :db_local_clean, true
set :assets_dir, 'public/uploads'
set :local_assets_dir, 'public/uploads'

set :puma_threads, [4, 16]
set :puma_workers, 0
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log, "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision

  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart

  # after :finished, :update_ssl
end
