ActiveRecord::Schema.define do
  self.verbose = false

  unless ActiveRecord::Base.connection.table_exists? :gifs
    create_table :gifs, force: true do |t|
      t.string :base_name
      t.string :directory
      t.integer :size

      t.timestamps
    end
  end

  unless ActiveRecord::Base.connection.table_exists? :dropbox_links
    create_table :dropbox_links, force: true do |t|
      t.belongs_to :gif, index: true, foreign_key: true
      t.string :dropbox_id, index: true
      t.string :remote_path
      t.integer :count, default: 0, index: true

      t.timestamps
    end
  end
end
