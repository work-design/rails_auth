class CreateAuthRoles < ActiveRecord::Migration
  def change
    create_table :auth_roles do |t|

      t.timestamps
    end
  end
end
