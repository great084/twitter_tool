class CreateReposts < ActiveRecord::Migration[6.0]
  def change
    create_table :reposts do |t|
      t.references :tweet, null: false, foreign_key: true
      t.timestamps
    end
  end
end
