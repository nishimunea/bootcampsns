worker_processes 2
working_directory '/var/www/app/sns/'
listen '/var/www/app/sns/tmp/sockets/unicorn.sock'
pid    'tmp/pids/unicorn.pid'
stderr_path 'log/unicorn.std.log'
stdout_path 'log/unicorn.err.log'
preload_app true
user 'www-data', 'www-data'

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "#{ server.config[:pid] }.oldbin"
  unless old_pid == server.pid
    begin
      Process.kill :QUIT, File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
