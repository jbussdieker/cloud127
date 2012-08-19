class CreateVms < ActiveRecord::Migration
  def change
    create_table :vms do |t|
      t.string :name
      t.string :status
      t.string :uuid
      t.string :template_uuid

      t.timestamps
    end
  end
end
