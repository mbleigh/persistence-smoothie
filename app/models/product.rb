class Product
  include MongoMapper::Document
  
  key :type, String
  key :image, String
  key :title, String
  
  key :info, Hash
  
  def sales
    Purchase.count(:conditions => {:product_id => self.id.to_s})
  end
  
  def self.by_social_graph(user)
    find(*Red.zrevrange("user:#{user.id}:social_sort", 0, 50))
  end
  
  def purchases
    Purchase.where(:product_id => self.id.to_s)
  end
  
  def users
    User.joins(:purchases).where('purchases.product_id' => self.id.to_s)
  end
  
  timestamps!
end