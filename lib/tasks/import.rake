namespace :import do
  desc "import municipalities from file to database"
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
  
  desc "import categories from file"
  task :categories => :environment do
    file = File.open(File.expand_path('../../../db/import/categories.csv', __FILE__))
    file.each do |line|
      attrs = line.split(";")
      c = Category.find_or_initialize_by_id(attrs[0])
      c.name  = attrs[1]
      c.description = attrs[2]
      if attrs[5].blank?
        c.ancestry = nil
      else 
        c.ancestry = attrs[5]
      end
      c.created_at = attrs[3]
      c.updated_at = attrs[4]
      puts "#{c.id} -- #{c.ancestry}"
      c.save!
    end
    file.close
  end
end


namespace :export do
  desc "export categories from database to file to database"
  task :categories => :environment do
    file = File.open(File.expand_path('../../../db/import/categories.csv', __FILE__), 'w')
    for category in Category.all
      file.write category.id.to_s + ";" + category.name + ";" + category.description + ";" + category.ancestry 
    end
    file.close
  end
end
