#!/bin/bash
set -e

case "$1" in
    develop)
        echo "Running Development Server"
        rm -f tmp/pids/server.pid
        exec bundle exec puma -e development -C config/puma.rb
        ;;
    test)
        echo "Running Test"
        rm -f tmp/pids/server.pid
        exec bundle exec rspec
        ;;
    staging)
        echo "Running Start"
        exec bundle exec puma -e staging -C config/puma.rb
        ;;
    start)
        echo "Running Start"
        exec bundle exec puma -e ${RAILS_ENV} -C config/puma.rb
        ;;
    *)
        exec "$@"
esac