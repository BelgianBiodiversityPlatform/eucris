timeout 30
listen 9456 
worker_processes 3
working_directory "/usr/local/www/apache22/www/data.biodiversa.org"
stderr_path "/usr/local/www/apache22/www/data.biodiversa.org/log/biogre-stderr.log"
stdout_path "/usr/local/www/apache22/www/data.biodiversa.org/log/biogre-stdout.log"
pid "/usr/local/www/apache22/www/data.biodiversa.org/unicorn.pid"

# Use "preload_app true"
preload_app true
