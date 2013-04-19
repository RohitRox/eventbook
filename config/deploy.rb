default_run_options[:pty] = true
require "bundler/capistrano"
# $:.unshift(File.expand_path('./lib', ENV['rvm_path']))  #Throws error in newer versions of RVM
# require "rvm/capistrano"
# require 'sidekiq/capistrano'

# set :stages, %w(production staging)
# set :default_stage, "production"
# require 'capistrano/ext/multistage'

set :rails_env, "production"
# set :rvm_ruby_string, '1.9.3-p290'
# set :rvm_type, :systemgg
# set :rvm_bin_path, "/usr/local/rvm/bin"

set :rake, "bundle exec rake"
set :application, "eventbook"
set :repository,  "git://github.com/RohitRox/eventbook.git"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "23.22.125.64"                          # Your HTTP server, Apache/etc
role :app, "23.22.125.64"                          # This may be the same as your `Web` server
role :db,  "23.22.125.64"#, :primary => true # This is where Rails migrations will run

set :user, "deploy"  # The server's user for deploys
set :port, 22

set :use_sudo, false

ssh_options[:forward_agent] = true # using your own private keys for git you might want to tell Capistrano to use agent forwarding with this command
set :scm, :git
# set :scm_username, 'sprout-deploy'

set :deploy_to, "/home/deploy/#{application}/"
set :deploy_via, :remote_cache
# set :deploy_env, 'production'
set :sudo_password, "deploy"

# role :web, "50.116.14.33"                          # Your HTTP server, Apache/etc
# role :app, "50.116.14.33"                          # This may be the same as your `Web` server
# role :db,  "50.116.14.33" , :primary => true # This is where Rails migrations will run

set :bundle_gemfile, "Gemfile"
set :bundle_dir,""
set :bundle_flags,"--deployment"
set :bundle_without, [:development, :test]

set :rails_env, "production"

#Pre Compile asset on the server
# load 'deploy/assets'
# run "cd #{release_path}; rake assets:precompile RAILS_ENV=production "

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do;end
  task :stop do ; end
  task :daemon_restart do
    run "#{current_release}/script/killer.sh"
  end
end

  namespace :assets do
    desc "Compress assets in a local file"
    task :compress_assets do
        run_locally("rm -rf public/assets/*")
        run_locally("bundle exec rake assets:precompile RAILS_ENV=development DEV_COMPILE=1")
        run_locally("touch assets.tgz && rm assets.tgz")
        run_locally("tar zcvf assets.tgz public/assets/")
        run_locally("mv assets.tgz public/assets/")
    end

    desc "Upload assets"
      task :upload_assets, :roles => [:app] do
        upload("public/assets/assets.tgz", release_path + '/assets.tgz')
        run "cd #{release_path}; tar zxvf assets.tgz; rm assets.tgz"
        run_locally("rm -rf public/assets/*")
      end
  end

  namespace :app_server do
    desc "Restart the web server"
      task :restart do
        run "cd #{current_release}; unicornctl restart"
      end
  end

  namespace :sidekiq do
    desc "Avoiding race condition for monit / sidekiq cap task simultaneously trying to start the sidekiq instance"
    task :start do
      puts "BAZINGA..."
    end
  end

  namespace :customs  do
    task :symlink, :roles => :app do
      # run "ln -nfs #{shared_path}/documents #{release_path}/public/documents"
      # run "ln -nfs #{shared_path}/splitted_images #{release_path}/public/splitted_images"
      run "ln -nfs #{shared_path}/tmp #{release_path}/tmp"
    end
  end

before "deploy:update_code", "assets:compress_assets"
after "deploy:update_code", "assets:upload_assets","app_server:restart"
#after :deploy, "customs:symlink"#,  'deploy:cleanup', 'deploy:daemon_restart'#,'customs:update_forms'