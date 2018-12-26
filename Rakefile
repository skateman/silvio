namespace :db do
  desc 'Migrate the database'
  task :migrate do
    migrations = ActiveRecord::Migration.new.migration_context.migrations
    ActiveRecord::Migrator.new(:up, migrations, nil).migrate
  end

  desc 'Delete the database'
  task :drop do
    FileUtils.rm_f(ENV['DATABASE_PATH'])
  end
end
