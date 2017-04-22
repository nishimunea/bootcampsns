class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user
      t.string :name
      t.string :pass
      t.boolean :admin
      t.string :icon_file_name

      t.timestamps null: false
    end
  end
end
