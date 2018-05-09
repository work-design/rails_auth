class CreateOauthUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :oauth_users do |t|
      t.references :user
      t.string :provider
      t.string :type
      t.string :uid
      t.string :name
      t.string :avatar_url
      t.string :state
      t.string :code
      t.string :access_token, limit: 1024
      t.timestamps
    end
  end
end
