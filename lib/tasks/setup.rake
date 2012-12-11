namespace :setup do
  desc "Make b.r.stefan.pettersson@gmail.com admin "
  task :first_admin => :environment do
    p = User.find_or_initialize_by_email('b.r.stefan.pettersson@gmail.com')
    if p
      p.is_admin = true
      p.save!  
      puts "Promoted b.r.stefan.pettersson@gmail.com to king of system."
    else
      puts "Sorry. Didn't promote any system_admin."
    end
  end
  
  task :heroku_collation => :environment do
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute 'ALTER TABLE municipalities ALTER COLUMN name TYPE varchar COLLATE "sv_SE";'
    ActiveRecord::Base.connection.execute 'ALTER TABLE organizers ALTER COLUMN name TYPE varchar COLLATE "sv_SE";'
  end
  
  namespace :paperclip do
    namespace :organizer do
      desc "Recreate different image sizes of the organizer photo."
      task :photo => :environment do
        Organizer.all.each do |organizer|
          puts organizer.name
          organizer.photo.reprocess!
        end
      end
      
      desc "Recreate different image sizes of the organizer logotype."
      task :logotype => :environment do
        Organizer.all.each do |organizer|
          puts organizer.name
          organizer.logotype.reprocess!
        end
      end
    end
  end
  
      
  
end


