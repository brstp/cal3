module ApplicationHelper
  def avatar_url(user)  
    default_url = "#{root_url}images/guest.png"  
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase  
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"   
  end
  
    def tree_select(categories, model, name, selected=0, level=0, init=true)
    html = ""
    # The "Root" option is added
    # so the user can choose a parent_id of 0
    if init
        # Add "Root" to the options
        html << "<select name=\"#{model}[#{name}]\" id=\"#{model}_#{name}\">\n"
        html << "\t<option value=\"0\""
        html << " selected=\"selected\"" if selected.parent_id == 0
        html << ">Root</option>\n"
    end

    if categories.length > 0
      level += 1 # keep position
      categories.collect do |cat|
        html << "\t<option value=\"#{cat.id}\" style=\"padding-left:#{level * 10}px\""
        html << ' selected="selected"' if cat.id == selected.parent_id
        html << ">#{cat.name}</option>\n"
        html << tree_select(cat.children, model, name, selected, level, false)
      end
    end
    html << "</select>\n" if init
    raw html
  end
  
  #  <%= tree_ul(@acts_as_list_collection) {|item| link_to h(item.name), :action => 'edit', :id => item } %>
  def tree_ul(acts_as_tree_set, init=true, &block)
    if acts_as_tree_set.size > 0
      ret = '<ul>'
      acts_as_tree_set.collect do |item|
        next if item.parent_id && init
        ret += '<li>'
        ret += yield item
        ret += tree_ul(item.children, false, &block) if item.children.size > 0
        ret += '</li>'
      end
      ret += '</ul>'
    end
  end

  
  def dig_tree( node )
    logger.info "***************"
    logger.info node.name
    if node.has_children?
      for child in node.children
        logger.info "--- barn ---"
        logger.info child.name
        dig_tree child
      end
    end
  end
  
end
