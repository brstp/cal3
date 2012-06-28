class Category < ActiveRecord::Base
  #include ActionView::Helpers::RawOutputHelper
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :events
  has_many :categories

  attr_accessible :name, :description, :ancestry, :mum, :parent

  has_ancestry

  #searchable :auto_index => true, :auto_remove => true do
  #  text :name
  #  text :description
  #end
  
  
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
    out = self.events.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"]).count
    if self.has_children?
      for child in self.children.order('name ASC')
        out += child.number_of_upcoming_events
      end
    end
    out
  end

  def upcoming_events max_no = 0
    
    if max_no > 0
      self.events.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"], :order => "start_datetime ASC", :limit => max_no)   
    else
      self.events.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"], :order => "start_datetime ASC")   
    end
    
  end

  
  def prefix
    str = ""
    self.depth.times {
      str += "_"
    }
    str
  end


  def climb selected = nil
    out = ""
    if self.depth > 0
      checked = (self.id == selected) ? "checked='checked'" : ""
      out << "<li>\n"
      out << "<label title = '#{self.description}'><input #{checked} id='event_category_id_#{self.id}' name='event[category_id]' value='#{self.id}' type='radio'>#{self.name} <span class = 'category_description'> #{self.description}</span></label>\n"
      out << "</li>\n"
    end
    if self.has_children?
      out << "<li>\n<ol class ='category-level-#{self.depth+1}'>\n"
      for child in self.children.order('name ASC')
        out << child.climb(selected)
      end
      out << "</ol>\n</li>\n"
    end
    out #raw out
  end


  def tree_to_list
    out = "<li>" + self.try(:name) + "</li>"
    if self.has_children?
      out += "<ol>"
      for child in self.children.order('name ASC')
        out += child.tree_to_list.to_s
      end
      out += "</ol>"
      out # raw out
    end

  end


end


