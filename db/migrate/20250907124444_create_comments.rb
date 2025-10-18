class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table   :comments do |t|
      t.references :user,         null: false, foreign_key: true
      t.references :event,        null: false, foreign_key: true
      t.text       :content,      null: false
      t.decimal    :score,        precision: 5, scale: 3
      t.boolean    :is_active,    null: false, default: true

      t.timestamps
    end
  end
end
