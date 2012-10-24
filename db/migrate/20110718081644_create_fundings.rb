class CreateFundings < ActiveRecord::Migration
  def self.up
    create_table :fundings do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :fundings
  end
end
