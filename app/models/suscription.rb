# == Schema Information
#
# Table name: suscriptions
#
#  id              :uuid             not null, primary key
#  user_id         :uuid
#  organization_id :uuid
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Suscription < ApplicationRecord
  belongs_to :user
  belongs_to :organization

end
