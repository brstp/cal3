module ApplicationHelper
  def avatar_url(user)  
    # default_url = "#{root_url}images/users/avatars/thumb/missing.png" 
    default_url = "#{request.protocol}#{request.host_with_port}#{asset_path("missing.png")}}"
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase  
    
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"   
  end
  
  def category_tree
    Category.all.first.subtree.all 
  end
  

end
