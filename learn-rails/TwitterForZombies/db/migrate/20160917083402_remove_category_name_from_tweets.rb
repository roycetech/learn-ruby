class RemoveCategoryNameFromTweets < ActiveRecord::Migration[5.0]
  def change
    remove_column :tweets, :category_name, :string
  end
end
