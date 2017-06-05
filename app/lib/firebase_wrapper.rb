class FirebaseWrapper
  BASE_URI = "https://addressbook-27a7c.firebaseio.com/"

  def self.client
    Firebase::Client.new(self::BASE_URI)
  end

  def self.create(organization_id, params)
    response = self.client.push(organization_id, params)
    raise Firebase::StandardError.new('There was a problem creating the contact') unless response.body
    response.body["name"]
  end

  def self.find(organization_id, key)
    response = self.client.get(organization_id, child: key)
    raise Firebase::RecordNotFound.new('Contact not found') unless response.body
    Contact.new(response.body[key])
  end

  def self.all(organization_id)
    response = self.client.get(organization_id)
    raise Firebase::RecordNotFound.new('Organization does not have contacts') unless response.body
    response.body.map { |contact| Contact.new(contact.last) }
  end

  def self.delete(organization_id, key)
    self.find(organization_id, key)
    self.client.delete(organization_id, child: key)
    true
  end
end

class Firebase::RecordNotFound < StandardError; end
class Firebase::StandardError < StandardError; end
