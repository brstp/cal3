namespace :maintenance do
  
  namespace :paperclip do
    
    namespace :organizer do
      
      namespace :photo do      
        desc "Recreate different image sizes of the organizer photo."
        task :reprocess => :environment do
          Organizer.all.each do |organizer|
            puts organizer.name
            organizer.photo.reprocess!
          end
        end # /reprocess
        
        desc "List all organizer photos in csv format"
        task :list => :environment do
          Organizer.all.each do |organizer|
            puts "\"#{organizer.name}\";\"#{organizer.id}\";\"#{organizer.photo.url(:medium)}\";\"#{organizer.photo.url(:original)}\";\"#{organizer.photo_file_size}\";\"#{organizer.photo_updated_at}\";\"#{organizer.photo_content_type}\""
          end
        end # /list
      end # /photo
      
      namespace :logotype do
        desc "Recreate different image sizes of the organizer logotype."
        task :reprocess => :environment do
          Organizer.all.each do |organizer|
            puts organizer.name
            organizer.logotype.reprocess!
          end
        end # /reprocess
        
        desc "List all organizer logotypes in csv format."
        task :list => :environment do
          Organizer.all.each do |organizer|
            puts "\"#{organizer.name}\";\"#{organizer.id}\";\"#{organizer.logotype.url(:medium)}\";\"#{organizer.logotype.url(:small)}\";\"#{organizer.logotype.url(:original)}\";\"#{organizer.logotype_file_size}\";\"#{organizer.logotype_updated_at}\";\"#{organizer.logotype_content_type}\""
          end
        end # /list        
      end # /logotype
    end # /organizer
    
    namespace :event do
      
      namespace :image1 do
      
        desc "Recreate different image sizes of the organizer photo."
        task :reprocess => :environment do
          Event.all.each do |event|
            puts event.subject
            event.image1.reprocess!
          end
        end # /reprocess
        
        desc "List all event images in csv format."
        task :list => :environment do
          Event.all.each do |event|
            puts "\"#{event.subject}\";\"#{event.id}\";\"#{event.image1.url(:medium)}\";\"#{event.image1.url(:original)}\";\"#{event.image1_file_size}\";\"#{event.image1_updated_at}\";\"#{event.image1_content_type}\""
          end
        end # /list
      end # /image1
    end # /event
  end # /paperclip
end # /maintenance