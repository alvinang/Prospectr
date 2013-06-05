class CreateTwitterUserSearches < ActiveRecord::Migration
  def change
    create_table :twitter_user_searches do |t|
      t.string :query
      t.text :result, limit: 16777215

      t.timestamps
    end

    add_index :twitter_user_searches, :query, :unique => true
  end
end
