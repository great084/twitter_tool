class CreateMedia < ActiveRecord::Migration[6.0]
  def change
    create_table :media do |t|
      t.references :tweet, null: false, foreign_key: true
      t.string :media_url, null: false

      t.timestamps
    end
  end
end
