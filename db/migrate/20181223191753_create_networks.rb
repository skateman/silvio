class CreateNetworks < ActiveRecord::Migration[5.0]
  def change
    create_table :networks do |t|
      t.string :name, :null => false
      t.string :address, :null => false
      t.string :netmask, :null => false
      t.references :user, :foreign_key => true, :null => false

      t.timestamps
    end
  end
end