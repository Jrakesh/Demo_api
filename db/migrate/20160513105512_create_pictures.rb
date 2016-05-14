class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :name
      t.string :image
      t.text :description
      t.integer :album_id

      t.timestamps null: false
    end
  end
end
