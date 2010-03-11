namespace :db do
  namespace :redis do
    task :reset => :environment do
      Red.flush_all
      puts "-- Redis Reset"
    end
  end
  
  namespace :mongo do
    task :reset => :environment do
      MongoMapper.connection.drop_database('schema4less')
      puts "-- MongoDB Reset"
    end
  end
end

namespace :dbs do
  desc 'Reset all databases (not just SQL)'
  task :reset => ['db:reset', 'dbs:nosql:reset']
  
  namespace :nosql do
    task :reset => ['db:redis:reset','db:mongo:reset']
  end
end