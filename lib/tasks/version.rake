namespace :version do
  
  desc "Show version"
  task :show => :environment do
    version_file = File.expand_path("app/views/application/_version.html.haml")
    app_version = File.open(version_file).first
    puts app_version
  end
  
  desc "Bump minor version"
  task :bump => :environment do
    version_file = File.expand_path("app/views/application/_version.html.haml")
    app_version = File.open(version_file).first
    app_array = app_version.split(".").map { |s| s.to_i }
    app_array[2] += 1
    new_version = "#{app_array[0]}.#{app_array[1]}.#{app_array[2]}"
    File.open(version_file, 'w') {|f| f.write(new_version) }
    commit_message = "Bumped version from #{app_version} to #{new_version}."
    puts commit_message
    sh "git add \"app/views/application/_version.html.haml\""
    sh "git commit -v -m \"#{commit_message}\" \"app/views/application/_version.html.haml\""
  end
  
  
end

