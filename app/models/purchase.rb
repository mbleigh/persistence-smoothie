class Purchase < ActiveRecord::Base
  belongs_to :user
  
  validates_uniqueness_of :product_id, :scope => :user_id
  
  def product=(product)
    self.product_id = product.id.to_s
    @product = product
  end
  
  def product
    @product ||= Product.find_by_id(product_id)
  end
  
  after_create :notify_followers, :compile_social_sort
  
  def notify_followers
    Notification.deliver! "<b><a href='/users/#{user.id}'>#{user.name}</a></b> purchased <b><a href='/products/#{product.id}'>#{product.title}</a></b>", :to => (user.follower_ids + [user.id])
  end
  
  def compile_social_sort
    user.follower_ids.each do |uid|
      Red.zincrby "user:#{uid}:social_sort", 1, product_id
    end
  end
end
