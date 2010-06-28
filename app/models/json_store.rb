class JsonStore < ActiveRecord::Base
  DIGITS = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a + %w{+ -}
  
  validate :data_is_valid
  
  def self.new_from(json)
    store = new
    store.create_key
    store.json = json
    store
  end
  
  def create_key
    self.key = String.new
    16.times do
      self.key += DIGITS[rand(DIGITS.size)].to_s
    end
  end
  
  def restore
    JSON.restore data
  end
end
