require "release_tagger"

set :autotagger_stages, [:development, :staging, :production]

set :application, "autotag-test"
set :repository,  "git@github.com:benaskins/autotag-test.git"
set :user, "benj"
set :use_sudo, false

role :app, "localhost"
role :web, "localhost"
role :db,  "localhost", :primary => true

set :scm, :git
set :scm_command, "/opt/local/bin/git"
set :stage, :staging

task :staging do
  set :deploy_to, "/u/apps/staging/#{application}"
end

task :production do
  set :stage, :production
  set :deploy_to, "/u/apps/production/#{application}"
end

namespace :deploy do
  task :restart do
    run "touch #{current_path}/restart.txt" 
  end
end

before "deploy:update_code", "release_tagger:set_branch"
after  "deploy", "release_tagger:create_tag"
after  "deploy", "release_tagger:write_tag_to_shared"
after  "deploy", "release_tagger:print_latest_tags"
