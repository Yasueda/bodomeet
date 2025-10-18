class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.references :user,           null: false, foreign_key: true
      t.references :group,          null: false, foreign_key: true
      t.boolean    :is_approval,    null:false, default: false

      t.timestamps
    end
  end
end
