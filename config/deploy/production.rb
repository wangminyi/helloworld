# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server '139.196.37.164', user: 'root', roles: %w{app db web} #, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}

set :stage,     :production
set :rails_env, "production"

set :rbenv_path,    "/root/.rbenv"
set :current_path,  "#{deploy_to}/current"

set :unicorn_config,  "#{current_path}/config/unicorn.rb"
set :unicorn_pid,     "#{current_path}/tmp/pids/unicorn.pid"
set :rackup_file,     "#{current_path}/config.ru"

set :linked_dirs, %w{
  log tmp/cache tmp/pids
}

# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
namespace :deploy do
  desc "Start unicorn in production mode"
  task :start do
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec unicorn -c #{fetch(:unicorn_config)} -D #{fetch(:rackup_file)} -E production"
        end
      end
    end
  end

  desc "Stop unicorn"
  task :stop do
    pid = fetch(:unicorn_pid)
    on roles :app do
      execute "if [ -f #{pid} ]; then kill -QUIT `cat #{pid}`; fi"
    end
  end

  desc "Restart unicorn"
  task :restart do
    pid = fetch(:unicorn_pid)
    on roles :app do
      execute "if [ -f #{pid} ]; then kill -USR2 `cat #{pid}`; fi"
    end
  end

  after :publishing, :restart
  
  namespace :db do
    desc "rake db:seed"
    task :seed do
      on roles :app do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "db:seed"
          end
        end
      end
    end
  end

  namespace :assets do 
    desc "rake assets:cdn"
    task :cdn do
      on roles :app do
        within release_path do 
          with rails_env: fetch(:rails_env) do
            execute :rake, "assets:cdn"
          end
        end
      end
    end
  end
end
