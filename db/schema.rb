# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  unless ActiveRecord::Base.connection.table_exists? :gifs
    create_table :gifs, force: true do |t|
      t.string :basename
      t.string :directory
      t.integer :size
      t.string :shared_link_id, index: true, foreign_key: true

      t.timestamps
    end
  end

  unless ActiveRecord::Base.connection.table_exists? :shared_links
    create_table :shared_links, id: false, force: true do |t|
      t.string :id, index: true, primary_key: true
      t.belongs_to :gif, index: true, foreign_key: true
      t.string :remote_path
      t.integer :count, default: 0, index: true

      t.timestamps
    end
  end
end
