module ApplicationHelper
  def gravatar_for(user)
    gravatar = Digest::MD5.hexdigest(user).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png"
  end
end
