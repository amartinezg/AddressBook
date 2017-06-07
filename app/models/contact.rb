class Contact

  attr_accessor :id, :name, :last_name, :address, :country, :email, :phone

  def initialize(params)
    @id = params["id"]
    @name = params["name"]
    @last_name = params["last_name"]
    @address = params["address"]
    @country = params["country"]
    @email = params["email"]
    @phone = params["phone"]
    @organization_id = params["organization_id"]
  end

  def self.find(organization_id, key)
    FirebaseWrapper.find(organization_id, key)
  end

  def self.all(organization_id)
    FirebaseWrapper.all(organization_id)
  end

  def self.create(organization_id, params)
    id = FirebaseWrapper.create(organization_id, params)
    self.new(params.merge!("id" => id))
  end

  def update
    params = Hash[instance_variables.reduce([]) do |arr, key|
      value = instance_variable_get key
      arr << [key.to_s.gsub('@',''), instance_variable_get(key)] if value
      arr
    end]
    FirebaseWrapper.update(params.delete("organization_id"), params.delete("id"), params)
    true
  end

  def destroy
    FirebaseWrapper.delete(@organization_id, @id)
  end

end
