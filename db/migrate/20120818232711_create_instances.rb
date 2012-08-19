class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|
      t.string :name
      t.string :status
      t.string :guid

      t.timestamps
    end
  end
end
