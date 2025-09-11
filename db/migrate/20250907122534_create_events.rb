class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.references :user, null: false, foreign_key: true
      t.string     :name, null: false
      t.text       :introduction
      t.datetime   :date, null: false
      t.datetime   :end_time, null: false
      t.string     :venue, null: false
      t.integer    :min_people, null: false
      t.integer    :max_people, null: false
      t.boolean    :is_held, null: false, default: false
      t.boolean    :is_active, null: false, default: true

      t.timestamps
    end

    add_index :events, :name, unique: true
    add_index :events, [:date, :venue]
  end
end
