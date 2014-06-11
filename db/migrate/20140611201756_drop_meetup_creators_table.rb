class DropMeetupCreatorsTable < ActiveRecord::Migration
  def up
    drop_table :meetup_creators
  end

  def down
    create_table :meetup_creators do |t|
      t.integer :user_id, null: false
    end
  end
end
