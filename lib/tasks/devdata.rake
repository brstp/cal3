namespace :devdata do
  
  desc "change start/stop dates on all events"
  task :changedates => :environment do
    for event in Event.all
      puts event.subject
      puts event.start_datetime
      puts event.stop_datetime
      puts " --> "
      event.start_datetime = event.start_datetime + 4.month
      event.stop_datetime = event.stop_datetime + 4.month
      puts event.start_datetime
      puts event.stop_datetime
      event.save!( :validate => false )
      puts "----------------------"
    end
  end
end
