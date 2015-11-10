require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina_sidekiq/tasks'
require 'mina/nginx'
require 'mina/puma'
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, '180.76.129.123'
set :user, "rails"
set :password, "qwer!1234"
set :deploy_to, '/home/rails/agency'
set :repository, 'git@github.com:john1228/agency.git'
set :branch, 'master'

# For system-wide RVM install.
#   set :rvm_path, '/usr/local/rvm/bin/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'log','config/application.yml','tmp/pids', 'tmp/sockets', 'config/puma.rb']
set :sidekiq_pid, "#{deploy_to}/tmp/pids/sidekiq.pid"
set :puma_pid, "#{deploy_to}/tmp/pids/puma.pid"

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.
#set :forward_agent, true     # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-1.9.3-p125@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/secrets.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/application.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml' and 'secrets.yml'."]

  # Puma needs a place to store its pid file and socket file.
  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/tmp/sockets")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/sockets")
  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/tmp/pids")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/pids")


  # queue %[
  #   repo_host=`echo $repo | sed -e 's/.*@//g' -e 's/:.*//g'` &&
  #   repo_port=`echo $repo | grep -o ':[0-9]*' | sed -e 's/://g'` &&
  #   if [ -z "${repo_port}" ]; then repo_port=22; fi &&
  #   ssh-keyscan -p $repo_port -H $repo_host >> ~/.ssh/known_hosts
  # ]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  # deploy do
  #
  # end

  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    # queue! "pwd"
    # #queue! "bin/cp.sh"
    # queue! echo_cmd "cp -rf #{deploy_to}/#{current_path}/app/assets/fonts #{deploy_to}/#{current_path}/public/assets/"

    #queue! %[cp #{deploy_to}/#{current_path}/app/assets/fonts/* #{deploy_to}/#{current_path}/public/assets/fonts/]
    invoke :'deploy:cleanup'

    to :launch do
      # queue! echo_cmd "cp -rf #{deploy_to}/#{current_path}/app/assets/fonts #{deploy_to}/#{current_path}/public/assets/"
      # queue! "cp -rf #{deploy_to}/#{current_path}/app/assets/fonts #{deploy_to}/#{current_path}/public/assets/"
      # #queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      #queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
      #invoke :'puma:restart'
      invoke :'puma:restart'
    end
  end
  # queue! %[cp #{deploy_to}/#{current_path}/app/assets/fonts/bootstrap/glyphicons-halflings-regular.svg #{deploy_to}/#{current_path}/public/assets//fonts/bootstrap/glyphicons-halflings-regular.svg ]
  # queue! %[cp #{deploy_to}/#{current_path}/app/assets/fonts/bootstrap/glyphicons-halflings-regular.ttf #{deploy_to}/#{current_path}/public/assets/fonts/bootstrap/glyphicons-halflings-regular.ttf ]
  # queue! %[cp #{deploy_to}/#{current_path}/app/assets/fonts/bootstrap/glyphicons-halflings-regular.woff #{deploy_to}/#{current_path}/public/assets/fonts/bootstrap/glyphicons-halflings-regular.woff ]
  # queue! %[cp #{deploy_to}/#{current_path}/app/assets/fonts/bootstrap/glyphicons-halflings-regular.woff2 #{deploy_to}/#{current_path}/public/assets/fonts/bootstrap/glyphicons-halflings-regular.woff2 ]


end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
