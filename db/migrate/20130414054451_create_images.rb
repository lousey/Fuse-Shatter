class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :order
      t.string :css_id
      t.integer :padding
      t.string :file
      t.references :sprite

      t.timestamps
    end
  end
end
