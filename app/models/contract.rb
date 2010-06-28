class Contract < ActiveRecord::Base
  DIGITS = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a + %w{+ -}
  
  validate :data_is_valid
  
  def self.new_from(json)
    contract = Contract.new
    contract.create_key
    contract.json = json
    contract
  end
  
  def create_key
    self.key = String.new
    16.times do
      self.key += DIGITS[rand(DIGITS.size)].to_s
    end
  end
  
  def data_is_valid
    json = JSON.restore data
    json.is_a?(Array) and json.all?{|h| h.is_a?(Hash)} and json.all?{|h| h.keys.sort == ['label', 'price', 'quantity']}
  end
  
  def json=(json)
    array = JSON.restore(json)
    self.data = array.collect{ |h|
      {
        'label' => h['label'].to_s,
        'price' => h['price'].to_f,
        'quantity' => h['quantity'].to_i
      }
    }.to_json
  end
  
  def restore
    JSON.restore data
  end
end
