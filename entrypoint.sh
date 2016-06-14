#!/bin/bash
set -e

case "$1" in
    develop)
        echo "Running Development Server"
        rm -f tmp/pids/server.pid
        exec bundle exec rails s -p 3030 -b '0.0.0.0'
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
        exec bundle exec puma -e production -C config/puma.rb
        ;;
    *)
        exec "$@"
esac