class Category < ActiveRecord::Base
  include ActionView::Helpers::RawOutputHelper
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :events
  has_many :categories
  
  attr_accessible :name, :description, :ancestry, :mum
  
  has_ancestry
  
  # before_save :connect_to_parent
  
  searchable :auto_index => true, :auto_remove => true do
    text :name
    text :description
  end
  
  def mum
    self.parent.object_id
  end
  
  def mum= category_id
    unless category_id.blank?
      self.parent = Category.find(category_id)
    end
  end
  
  
  def and_mum
    category = self
    out_str = ""
    while category.depth > 0
      out_str = category.name + " > " + out_str 
      category = category.parent
    end    
    out_str.to(out_str.length - 4)
  end
  
  
  def to_s
    self.name
  end
  
  def number_of_upcoming_events
    self.events.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"]).count
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


