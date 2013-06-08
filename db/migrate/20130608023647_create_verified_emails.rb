class CreateVerifiedEmails < ActiveRecord::Migration
  def change
    create_table :verified_emails do |t|
      t.string :query
      t.text :response

      t.timestamps
    end
  end
end
