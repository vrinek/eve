class Contract < JsonStore
  set_table_name :contracts
  
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
end