class Syndication < ActiveRecord::Base
  attr_accessible :organizer_id, :syndicated_organizer_id
  belongs_to      :organizer
  belongs_to      :syndicated_organizer,
                  :class_name => 'Organizer',
                  :foreign_key => :syndicated_organizer_id
                                    
  validates_presence_of  :organizer_id
  validates   :syndicated_organizer_id, 
              :presence => true, 
              :uniqueness => { :scope => :organizer_id }  

end
