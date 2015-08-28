class UpdateFeedEntryColumnNames < ActiveRecord::Migration
  def change
  	add_column :feed_entries, :s_event_type, :string
  	add_column :feed_entries, :s_event_start, :string
  	add_column :feed_entries, :dt_event_start, :datetime
  end
end
