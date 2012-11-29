# encoding: UTF-8

class FriendlyIdSlug < ActiveRecord::Base
end

namespace :friendly_id do
  
  desc "Add existing slugs"
  task :add_existing_slugs => :environment do
    for o in Organizer.all
      puts o.name
      puts o.id
      puts o.slug
      
      friend = FriendlyIdSlug.find_by_slug_and_sluggable_id_and_sluggable_type(o.slug, o.id, "Organizer")
      
      unless friend
        puts "adding slug"
        s = FriendlyIdSlug.new
        s.slug = o.slug
        s.sluggable_id = o.id
        s.sluggable_type = "Organizer"
        s.created_at = Time.now
        s.save
      end
      puts "----------------------"
      puts
    end
    
    for o in Municipality.all
      puts o.name
      puts o.id
      puts o.slug
      
      friend = FriendlyIdSlug.find_by_slug_and_sluggable_id_and_sluggable_type(o.slug, o.id, "Municipality")
      
      unless friend
        puts "adding slug"
        s = FriendlyIdSlug.new
        s.slug = o.slug
        s.sluggable_id = o.id
        s.sluggable_type = "Municipality"
        s.created_at = Time.now
        s.save
      end
      puts "----------------------"
      puts
    end
    
    for o in Event.all
      puts o.subject
      puts o.id
      puts o.slug
      
      friend = FriendlyIdSlug.find_by_slug_and_sluggable_id_and_sluggable_type(o.slug, o.id, "Event")
      
      unless friend
        puts "adding slug"
        s = FriendlyIdSlug.new
        s.slug = o.slug
        s.sluggable_id = o.id
        s.sluggable_type = "Event"
        s.created_at = Time.now
        s.save
      end
      puts "----------------------"
      puts
    end
    
    
  end
  
  task :resave => :environment do
    Organizer.find_each(&:save)
    Municipality.find_each(&:save)
    Event.find_each(&:save)
  end
end