class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :feed_type
      t.integer :user_id
      t.string :image_file_name
      t.string :exif
      t.string :comment

      t.timestamps null: false
    end
  end
end
