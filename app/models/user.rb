class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :registerable, :rememberable, :authenticatable
  
  def following_ids; FriendSet.following_ids_for(self) end
  def followings; User.where(:id => following_ids) end
  def following?(user); FriendSet.following?(self, user) end
  def follow!(user); FriendSet.follow!(self, user) end
  
  def friend_ids; FriendSet.friend_ids_for(self) end
  def friends; User.where(:id => friend_ids) end
  
  def follower_ids; FriendSet.follower_ids_for(self) end
  def followers; User.where(:id => follower_ids) end
  
  has_many :purchases do
    def products
      ids = all.collect{|p| Mongo::ObjectID.from_string(p.product_id)}
      Product.find(*ids)
    end
  end
  
  def products
    purchases.products
  end
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
end
