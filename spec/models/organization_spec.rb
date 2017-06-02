# == Schema Information
#
# Table name: organizations
#
#  id             :uuid             not null, primary key
#  name           :string
#  address        :string
#  country        :string
#  contact_person :string
#  email          :string
#  web_site       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe Organization, type: :model do
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:country) }
  it { should validate_presence_of(:contact_person) }

end
