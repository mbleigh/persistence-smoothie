class Notification
  def self.deliver!(message, opts = {})
    opts[:to].each do |follower_id|
      Red.lpush "user:#{follower_id}:notifications", {:message => message, :timestamp => Time.now}.to_json
    end
  end
  
  def self.for_user(user, limit = -1)
    Red.lrange("user:#{user.id}:notifications", 0, limit).map{|n| Notification.new(ActiveSupport::JSON.decode(n))}
  end
  
  def initialize(attributes = {})
    @attributes = attributes
  end
  
  def method_missing(name, *args)
    super unless @attributes && @attributes.key?(name.to_s)
    @attributes[name.to_s]
  end
end