class CreateOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :organizations, id: :uuid do |t|
      t.string :name
      t.string :address
      t.string :country
      t.string :contact_person
      t.string :email
      t.string :web_site

      t.timestamps
    end
  end
end
