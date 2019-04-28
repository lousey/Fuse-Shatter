class CreateSprites < ActiveRecord::Migration
  def change
    create_table :sprites do |t|
      t.string :name
      t.string :file

      t.references :user
      t.timestamps
    end
  end
end
