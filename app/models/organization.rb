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

class Organization < ApplicationRecord
  validates :name, :address, :country, :contact_person, presence: true
end
