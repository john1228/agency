# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'e-mxing'
set :repo_url, 'https://github.com/john1228/e-mxing.git'

set :linked_files, %w{config/database.yml} #需要做链接的文件，一般database.yml和部分配置文件
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}


namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
    end
  end
  after :restart, :'puma:restart' #添加此项重启puma
  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end