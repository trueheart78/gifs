ActiveRecord::Schema.define do
  self.verbose = false

  unless ActiveRecord::Base.connection.table_exists? :gifs
    create_table :gifs, force: true do |t|
      t.string :name
      t.integer :size

      t.timestamps
    end
  end

  unless ActiveRecord::Base.connection.table_exists? :dropbox_links
    create_table :dropbox_links, force: true do |t|
      t.belongs_to :gifs, index: true
      t.string :remote_path
      t.string :dropbox_id

      t.timestamps
    end
  end
end
