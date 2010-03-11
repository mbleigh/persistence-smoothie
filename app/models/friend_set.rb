class FriendSet
  def self.following_ids_for(user)
    Red.smembers("user:#{user.id}:followings")
  end
  
  def self.follower_ids_for(user)
    Red.smembers("user:#{user.id}:followers")
  end
  
  def self.follow!(user, followed_user)
    return false if user == followed_user
    Red.sadd("user:#{user.id}:followings", followed_user.id)
    Red.sadd("user:#{followed_user.id}:followers", user.id)
    true
  end
  
  def self.following?(user, other_user)
    Red.sismember("user:#{user.id}:followings", other_user.id)
  end
  
  def self.friend_ids_for(user)
    Red.sinter("user:#{user.id}:followings", "user:#{user.id}:followers")
  end
end