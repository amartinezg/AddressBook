class CreateSuscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :suscriptions, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true
      t.references :organization, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
