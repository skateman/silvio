class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name, :null => false
      t.string :token, :null => false
      t.string :address, :null => false
      t.references :network, :foreign_key => true, :null => false
      t.references :user, :foreign_key => true, :null => false

      t.timestamps
    end
    add_index :clients, :token, unique: true
  end
end
