task :red_button => ['dbs:reset', 'populate:users', 'populate:amazon:all', 'populate:follow', 'populate:purchase']

namespace :populate do
  desc 'Create a bunch of superheroes'
  task :users => :environment do
    File.open('futurama_characters.txt') do |f| 
      while name = f.gets.strip!
        u = User.new(
          :email => name.gsub(/[^a-z0-9_-]/i,'').underscore + '@example.com',
          :password => 'test',
          :password_confirmation => 'test'
        )
        u.name = name
        puts " + #{name}" if u.save
      end
    end
  end
  
  desc 'Have everyone follow some random people.' 
  task :follow => :environment do
    puts "== Populating Follows..."
    User.all.each do |u|
      User.all(:order => "RANDOM()", :limit => (rand(User.count - 10)+10)).each do |f|
        puts " + #{u.name} is now following #{f.name}" if u.follow!(f)
      end
    end
  end
  
  desc 'Have everyone buy some random stuff.'
  task :purchase => :environment do
    puts "== Populating Purchases..."
    products = Product.all
    
    (User.count * 8).times do
      u = User.first(:order => "RANDOM()")
      p = products.sort_by{rand}.first
      puts " + #{u.name} bought #{p.title}" if Purchase.create(:user => u, :product => p)
    end
  end
  
  desc 'populate the database with some books about Ruby' 
  namespace :amazon do    
    task :books => :environment do
      puts '== Populating Books...'
    
      for page in 1..4
        results = Amazon::Ecs.item_search('ruby programming', {:response_group => 'Medium', :sort => 'salesrank', :item_page => page})
    
        results.items.each do |item|
          next unless item.get('productgroup') == 'Book'
          atts = item.get_hash(:itemattributes)
          Product.create!(
            :type => atts[:productgroup],
            :title => atts[:title],
            :image => item.get('smallimage/url'),
            :info => {
              :release_date => Time.parse(atts[:publicationdate]),          
              :author => atts[:author],
              :pages => atts[:numberofpages],
              :publisher => atts[:publisher]
            }
          )
          puts " + #{atts[:title]} by #{atts[:author]}"
        end      
      end
    end
    
    task :movies => :environment do
      puts '== Populating Movies...'
      for query in %w(zombies)
        for page in 1..4
          results = Amazon::Ecs.item_search(query, {:search_index => 'DVD', :response_group => 'Medium', :sort => 'salesrank', :item_page => page})
        
          results.items.each do |movie|
            atts = movie.get_hash(:itemattributes)
            Product.create(
              :type => 'Movie',
              :image => movie.get('smallimage/url'),
              :title => movie.get('title'),
              :info => {
                :cast => movie.get_array('actor'),
                :review => movie.get('editorialreview/content'),
                :running_time => movie.get('itemattributes/runningtime').to_i
              }
            )
            puts " + #{atts[:title]}"
          end
        end      
      end
    
      puts "Total of #{results.total_results} matches"
    end
    
    task :all => ['populate:amazon:books', 'populate:amazon:movies']
  end
  
  task :all => ['populate:users', 'populate:follow', 'populate:amazon:all', 'populate:purchase']
end