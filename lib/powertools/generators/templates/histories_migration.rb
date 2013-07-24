class CreatePtHistoriesTable < ActiveRecord::Migration
  def change
    create_table :pt_histories do |t|
      t.belongs_to :associated, polymorphic: true, index: true
      t.belongs_to :trackable, polymorphic: true, index: true
      t.text :trackable_changes
      t.string :action
      t.string :permission, length: 30, null: false
      t.text :extras

      t.belongs_to :creator, index: true
      t.timestamps
    end
  end
end
