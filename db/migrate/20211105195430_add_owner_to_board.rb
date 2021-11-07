# frozen_string_literal: true

class AddOwnerToBoard < ActiveRecord::Migration[6.1]
  def change
    add_column :boards, :owner_id, :integer
  end
end
