namespace :import do
  desc "import data from files to database"
  task :organizers => :environment do
    file = File.open(File.expand_path('../../../db/import/organizers.csv', __FILE__))
    file.each do |line|
      attrs = line.split(",")
      #"name","description","website"
      p = Organizer.new
      p.name = attrs[0]
      p.description = attrs[1]
      p.website = attrs[2]
      p.save!
    end
  end
end


