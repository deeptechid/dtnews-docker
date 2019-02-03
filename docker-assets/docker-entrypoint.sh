#!/bin/sh

# Install any needed gems. This is useful if you mount
# the project as a volume to /dtnews
# bundle install

# Used for simple logging purposes.
timestamp="date +\"%Y-%m-%d %H:%M:%S\""
alias echo="echo \"$(eval $timestamp) -$@\""

# Get current state of database.
db_version=$(bundle exec rake db:version)
db_status=$?

echo "DB Version: ${db_version}"

# Provision Database.
if [ "$db_version" = "Current version: 0" ]; then
  echo "Loading schema."
  bundle exec rake db:schema:load
  echo "Migrating database."
  bundle exec rake db:migrate
  echo "Seeding database."
  bundle exec rake db:seed
else
  echo "Migrating database."
  bundle exec rake db:migrate
fi

# Compile our assets.
if [ "$RAILS_ENV" = "production" ]; then
  bundle exec rake assets:precompile
fi

# Start the rails application.
bundle exec rails server -b 0.0.0.0 &
pid="$!"
trap "echo 'Stopping DTNews - pid: $pid'; kill -SIGTERM $pid" SIGINT SIGTERM

# Wait for process to end.
while kill -0 $pid > /dev/null 2>&1; do
    wait
done
echo "Exiting"
