class FirebaseWrapper
  BASE_URI = "https://addressbook-27a7c.firebaseio.com/"

  def self.client
    Firebase::Client.new(self::BASE_URI)
  end

  def self.sanitize_params(params)
    params.slice("name", "last_name", "address", "country", "email", "phone")
  end

  def self.create(organization_id, params)
    params = sanitize_params(params)
    raise FirebaseWrapper::StandardError.new('There are not valid data to create contact') if params.keys.empty?
    response = self.client.push(organization_id, params)
    raise FirebaseWrapper::StandardError.new('There was a problem creating the contact') unless response.body
    response.body["name"]
  end

  def self.find(organization_id, key)
    response = self.client.get(organization_id, child: key)
    raise FirebaseWrapper::RecordNotFound.new('Contact not found') unless response.body && response.body[key]
    Contact.new(response.body[key].merge("id" => key))
  end

  def self.all(organization_id)
    response = self.client.get(organization_id)
    raise FirebaseWrapper::RecordNotFound.new('Organization does not have contacts') unless response.body
    response.body.map { |contact| Contact.new(contact.last.merge("id" => contact.first)) }
  end

  def self.update(organization_id, key, data)
    path = "#{organization_id}/#{key}"
    params = sanitize_params(data)
    raise FirebaseWrapper::StandardError.new('There are not valid data to update contact') if params.keys.empty?
    self.find(organization_id, key)
    self.client.update(path, sanitize_params(data))
    true
  end

  def self.delete(organization_id, key)
    path = "#{organization_id}/#{key}"
    self.find(organization_id, key)
    self.client.delete(path)
    true
  end
  
  class RecordNotFound < StandardError; end
  class StandardError < StandardError; end

end

