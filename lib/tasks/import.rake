namespace :import do
  desc "import data from files to database"
  task :municipalities => :environment do
    file = File.open(File.expand_path('../../../db/import/municipalities.csv', __FILE__))
    file.each do |line|
      attrs = line.split(",")
      #"admin_no","short_name","parent_admin_no","name"
      p = Municipality.find_or_initialize_by_id(attrs[0])
      p.admin_no = attrs[0]
      p.short_name = attrs[1]
      p.parent_admin_no = attrs[2]
      p.name = attrs[3]
      p.save!
    end
  end
end


