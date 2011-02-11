class Category < ActiveRecord::Base
  include ActionView::Helpers::RawOutputHelper
  validates_presence_of :name
  has_many :events
  has_many :categories
  
  attr_accessible :name, :description, :ancestry
  
  has_ancestry
  
  def prefix
    str = ""
    self.depth.times {
      str += "_"
    }
    str 
  end

  def name # Fortsätt här. Byt namn internt på name (kanske) och låt name vara wrapper...
    str = ""
    self.depth.times {
      str += "_"
    }
    str 
  end

  def self.tree
  node = Category.first.root
 
  node.climb
  
  end
  
  def climb
    html = ""
    html << self.prefix + self.name + '<br />'
    # logger.info "----- in #{self.name} ----"
    # logger.info self.prefix + self.name
    if self.has_children?
    # logger.info "----- has #{self.children.count.to_s} ----"
      for child in self.children
        html << child.climb
      end
    end
    
    raw html
  end
  

end


