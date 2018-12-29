class DropUsers < ActiveRecord::Migration[5.0]
  drop_table :networks_users
  remove_reference :networks, :user, :index => true
  remove_reference :clients, :user, :index => true
  drop_table :users
end
