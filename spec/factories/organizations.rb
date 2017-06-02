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
FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }
    address { Faker::Address.country }
    country { Faker::Number.number(10) }
    contact_person { Faker::Name.name }
    email { Faker::Internet.email }
    web_site { Faker::Internet.url }
  end
end
