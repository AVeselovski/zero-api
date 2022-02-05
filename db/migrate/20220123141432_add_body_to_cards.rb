class AddBodyToCards < ActiveRecord::Migration[6.1]
  def change
    add_column :cards, :body, :text
  end
end
