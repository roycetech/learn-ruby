class AddPrivacyToTweets < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :privacy, :boolean
  end
end
