class CreateOrgunits < ActiveRecord::Migration
  def self.up
    create_table :orgunits do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :orgunits
  end
end
