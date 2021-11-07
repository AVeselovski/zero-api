# frozen_string_literal: true

class CreateBoardUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :board_users do |t|
      t.integer :board_id
      t.integer :user_id
      t.timestamps
    end
  end
end
