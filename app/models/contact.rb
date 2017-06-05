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

  def destroy
    FirebaseWrapper.delete(@organization_id, @id)
  end

end
