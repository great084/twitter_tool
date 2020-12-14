class AddTokenAndSecretToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :token
      t.string :secret
    end
  end
end
