class CreateWeapons < ActiveRecord::Migration[5.0]
  def change
    create_table :weapons do |t|
      t.string :name
      t.float :damage
      t.references :zombie, foreign_key: true

      t.timestamps
    end
  end
end
