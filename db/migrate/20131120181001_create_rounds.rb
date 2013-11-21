class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.integer :round
      t.integer :player1
      t.integer :player2
      t.integer :player3
      t.integer :player4
      t.integer :ocean

      t.timestamps
    end
  end
end
