class AddScopusIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :scopus_id, :string
    add_column :users, :publication_count, :integer
  end
end
