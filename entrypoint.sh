#!/bin/bash
set -e

case "$1" in
    develop)
        echo "Running Development Server"
        bundle exec rake dir:exists RAILS_ENV=development
        rm -f tmp/pids/server.pid
        exec bundle exec rails s -p 3030 -b '0.0.0.0'
        ;;
    test)
        echo "Running Test"
        bundle exec rake dir:exists RAILS_ENV=test
        rm -f tmp/pids/server.pid
        exec bundle exec rspec
        ;;
    staging)
        echo "Running Start"
        bundle exec rake dir:exists RAILS_ENV=staging
        rm -f tmp/pids/server.pid
        exec bundle exec puma -e staging -C config/puma.rb
        ;;
    start)
        echo "Running Start"
        bundle exec rake dir:exists RAILS_ENV=production
        rm -f tmp/pids/server.pid
        export SECRET_KEY_BASE=$(rake secret)
        exec bundle exec puma -e ${RAILS_ENV} -C config/puma.rb
        ;;
    *)
        exec "$@"
esac
