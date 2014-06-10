class CreateMeetupCreators < ActiveRecord::Migration
  def change
    create_table :meetup_creators do |t|
      t.integer :user_id, null: false
    end
  end
end
