# encoding: UTF-8
#require "net/http"
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
        
        desc "List all organizer logotypes in csv format."
        task :list => :environment do
          Organizer.all.each do |organizer|
            puts "\"#{organizer.name}\";\"#{organizer.id}\";\"#{organizer.logotype.url(:medium)}\";\"#{organizer.logotype.url(:small)}\";\"#{organizer.logotype.url(:original)}\";\"#{organizer.logotype_file_size}\";\"#{organizer.logotype_updated_at}\";\"#{organizer.logotype_content_type}\""
          end
        end # /list        
        
        desc "Sanitize organizer photo file names. Report in csv."
        task :sanitize => :environment do
          Organizer.all.each do |organizer|
            progress = "\"#{Time.now.to_i}\""
            progress << ";\"#{organizer.id}\""
            if organizer.photo.exists?
              progress << ";\"exists\""
              if organizer.photo_content_type.split("/")[0] == "image"
                progress << ";\"is an image\""
                if organizer.photo_file_size.to_i > 0
                  progress << ";\"original has a size\""
                  url = URI.parse(organizer.photo.url)
                  req = Net::HTTP.new(url.host, url.port)
                  res = req.request_head(url.path)
                  if res.code == "200" # orig
                    progress << ";\"original is there, success\""
                    organizer.photo = url
                    progress << ";\"Status: #{organizer.save}\""
                  else # not 200
                    progress << ";\"original is not there\""
                    url = URI.parse(organizer.photo.url(:medium))
                    req = Net::HTTP.new(url.host, url.port)
                    res = req.request_head(url.path)
                    if res.code == "200" # medium
                      progress << ";\"medium is there, success\""
                      organizer.photo = url
                      progress << ";\"Status: #{organizer.save}\""
                    else # not 200
                      progress << ";\"medium is not there, deleted, tell #{organizer.updated_by}\""
                      organizer.photo.destroy
                      progress << ";\"Status: #{organizer.save}\""
                    end # /medium 200
                  end # /orig 200
                else # zero size
                  progress << ";\"original has zero size\""
                  # medium
                  url = URI.parse(organizer.photo.url(:medium))
                  req = Net::HTTP.new(url.host, url.port)
                  res = req.request_head(url.path)
                  if res.code == "200"
                    progress << ";\"medium is there, success\""
                    organizer.photo = url
                    progress << ";\"Status: #{organizer.save}\""
                  else # not 200
                    progress << ";\"medium is not there, deleted, tell #{organizer.updated_by}\""
                    organizer.photo.destroy
                    progress << ";\"Status: #{organizer.save}\""
                  end #/
                end # /size
              else # not image
                progress << ";\"is not an image, deleted, tell #{organizer.updated_by}\""
                organizer.photo.destroy
                progress << ";\"Status: #{organizer.save}\""
              end #/ image?
            else # no file
                # cool
              progress << ";\"does not exist, success.\""
            end #/exists?
            puts progress
          end
        end # /sanitize
        
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
        
        desc "Sanitize organizer logotype file names. Report in csv."
        task :sanitize => :environment do
          Organizer.all.each do |organizer|
            progress = "\"#{Time.now.to_i}\""
            progress << ";\"#{organizer.id}\""
            if organizer.logotype.exists?
              progress << ";\"exists\""
              if organizer.logotype_content_type.split("/")[0] == "image"
                progress << ";\"is an image\""
                if organizer.logotype_file_size.to_i > 0
                  progress << ";\"original has a size\""
                  url = URI.parse(organizer.logotype.url)
                  req = Net::HTTP.new(url.host, url.port)
                  res = req.request_head(url.path)
                  if res.code == "200" # orig
                    progress << ";\"original is there, success\""
                    organizer.logotype = url
                    progress << ";\"Status: #{organizer.save}\""
                  else # not 200
                    progress << ";\"original is not there\""
                    url = URI.parse(organizer.logotype.url(:medium))
                    req = Net::HTTP.new(url.host, url.port)
                    res = req.request_head(url.path)
                    if res.code == "200" # medium
                      progress << ";\"medium is there, success\""
                      organizer.logotype = url
                      progress << ";\"Status: #{organizer.save}\""
                    else # not 200
                      progress << ";\"medium is not there, deleted, tell #{organizer.updated_by}\""
                      organizer.logotype.destroy
                      progress << ";\"Status: #{organizer.save}\""
                    end # /medium 200
                  end # /orig 200
                else # zero size
                  progress << ";\"original has zero size\""
                  # medium
                  url = URI.parse(organizer.logotype.url(:medium))
                  req = Net::HTTP.new(url.host, url.port)
                  res = req.request_head(url.path)
                  if res.code == "200"
                    progress << ";\"medium is there, success\""
                    organizer.logotype = url
                    progress << ";\"Status: #{organizer.save}\""
                  else # not 200
                    progress << ";\"medium is not there, deleted, tell #{organizer.updated_by}\""
                    organizer.logotype.destroy
                    progress << ";\"Status: #{organizer.save}\""
                  end #/
                end # /size
              else # not image
                progress << ";\"is not an image, deleted, tell #{organizer.updated_by}\""
                organizer.logotype.destroy
                progress << ";\"Status: #{organizer.save}\""
              end #/ image?
            else # no file
                # cool
              progress << ";\"does not exist, success.\""
            end #/exists?
            puts progress
          end
        end # /sanitize
        
      end # /logotype
    end # /organizer
    
    
    
    namespace :event do
      
      namespace :image1 do
      
        desc "Recreate different image sizes of the event image."
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
        
        desc "Sanitize organizer photo file names. Report in csv."
        task :sanitize => :environment do
          Event.all.each do |event|
            progress = "\"#{Time.now.to_i}\""
            progress << ";\"#{event.id}\""
            if event.image1.exists?
              progress << ";\"exists\""
              if event.image1_content_type.split("/")[0] == "image"
                progress << ";\"is an image\""
                if event.image1_file_size.to_i > 0
                  progress << ";\"original has a size\""
                  url = URI.parse(event.image1.url)
                  req = Net::HTTP.new(url.host, url.port)
                  res = req.request_head(url.path)
                  if res.code == "200" # orig
                    progress << ";\"original is there, success\""
                    event.image1 = url
                    progress << ";\"Status: #{event.save}\""
                  else # not 200
                    progress << ";\"original is not there\""
                    url = URI.parse(event.image1.url(:medium))
                    req = Net::HTTP.new(url.host, url.port)
                    res = req.request_head(url.path)
                    if res.code == "200" # medium
                      progress << ";\"medium is there, success\""
                      event.image1 = url
                      progress << ";\"Status: #{event.save}\""
                    else # not 200
                      progress << ";\"medium is not there, deleted, tell #{event.updated_by}\""
                      event.image1.destroy
                      progress << ";\"Status: #{event.save}\""
                    end # /medium 200
                  end # /orig 200
                else # zero size
                  progress << ";\"original has zero size\""
                  # medium
                  url = URI.parse(event.image1.url(:medium))
                  req = Net::HTTP.new(url.host, url.port)
                  res = req.request_head(url.path)
                  if res.code == "200"
                    progress << ";\"medium is there, success\""
                    event.image1 = url
                    progress << ";\"Status: #{event.save}\""
                  else # not 200
                    progress << ";\"medium is not there, deleted, tell #{event.updated_by}\""
                    event.image1.destroy
                    progress << ";\"Status: #{event.save}\""
                    # destroy
                  end #/
                end # /size
              else # not image
                progress << ";\"is not an image, deleted, tell #{event.updated_by}\""
                event.image1.destroy
                progress << ";\"Status: #{event.save}\""
              end #/ image?
            else # no file
                # cool
              progress << ";\"does not exist, success.\""
            end #/exists?
            puts progress
          end
        end # /sanitize
   
      end # /image1
    end # /event
  end # /paperclip
end # /maintenance