class Category < ActiveRecord::Base
  include ActionView::Helpers::RawOutputHelper
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :events
  has_many :categories
  
  attr_accessible :name, :description, :ancestry
  
  has_ancestry
  
  searchable :auto_index => true, :auto_remove => true do
    text :name
    text :description
  end
  
  def to_s
    self.name
  end
  
  def prefix
    str = ""
    self.depth.times {
      str += "_"
    }
    str 
  end

  # def name # Fortsätt här. Byt namn internt på name (kanske) och låt name vara wrapper...
    # str = ''
    # self.depth.times {
      # str += "_"
    # }
    # str 
  # end
  
  def select_category
    Category.all
  end

  def tree
    node = Category.first.root
    node.climb
  end
  
  # def climb
    # html = ""
    # html << self.prefix + self.name + '<br />'
    # logger.info "----- in #{self.name} ----"
    # logger.info self.prefix + self.name
    # if self.has_children?
    # logger.info "----- has #{self.children.count.to_s} ----"
      # for child in self.children
        # html << child.climb
      # end
    # end
    
    # raw html
  # end
  
  
  def climb
    out = []
    out << self.try(:name)
    if self.has_children?
      for child in self.children
        out << child.climb
      end
    end
    out
  end

end


