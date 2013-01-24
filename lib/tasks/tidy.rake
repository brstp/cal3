namespace :tidy do
  
  desc "remove images2 and image3 from storage"
  task :obsolete_images => :environment do
    for event in Event.all
      puts "#{event.id} -- #{event.subject}"
      if event.image2.exists?
        puts "removing image2"
        event.image2.detroy
      end
      if event.image3.exists?
        puts "removing image3"
        event.image3.destroy
      end
      puts "----------------------"
    end
  end

end
