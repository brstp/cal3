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
end


