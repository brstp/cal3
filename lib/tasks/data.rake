namespace :data do
  desc "import data from files to database"
  task :import => :environment do
    file = File.open(File.expand_path('../../../db/import/municipality.csv', __FILE__))
    file.each do |line|
      attrs = line.split(",")
      p = Municipality.find_or_initialize_by_id(attrs[0])
      p.name = attrs[1]
      p.save!
    end
  end
end


