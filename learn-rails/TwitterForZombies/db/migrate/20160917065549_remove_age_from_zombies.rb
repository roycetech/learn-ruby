class RemoveAgeFromZombies < ActiveRecord::Migration[5.0]
  def change
    remove_column :zombies, :age, :integer
  end
end
