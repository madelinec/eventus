class CreateFeedEntries < ActiveRecord::Migration
  def change
    create_table :feed_entries do |t|
      t.string :title
      t.text :summary
      t.string :link
      t.datetime :published
      t.string :guid

      t.timestamps
    end
  end
end
