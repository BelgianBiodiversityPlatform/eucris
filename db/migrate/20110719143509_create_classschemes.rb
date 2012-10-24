class CreateClassschemes < ActiveRecord::Migration
  def self.up
    create_table :classschemes do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :classschemes
  end
end
