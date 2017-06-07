# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  name                   :string
#  nickname               :string
#  image                  :string
#  email                  :string
#  tokens                 :json
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string           default("regular")
#

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    password_confirmation { "#{password}" }
    name { Faker::Name.name }

    transient do
      organizations_count 1
    end

    after(:create) do |user, evaluator|
      create_list(:organization, evaluator.organizations_count, users: [user])
    end    

    trait :admin do
      role "admin"
    end

    trait :regular do
      role "regular"
    end

    factory :admin_user, traits: [:admin]
    factory :regular_user, traits: [:regular]
  end
end
