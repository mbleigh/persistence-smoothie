require 'gloo/active_record'

class Product
  include MongoMapper::Document
  
  key :type, String
  key :image, String
  key :title, String

  key :info, Hash
  
  def purchases
    Purchase.where(:product_id => self.id.to_s)
  end
  
  def users
    User.join(:purchases).where('purchases.product_id' => self.id.to_s)
  end
  
  timestamps!
end