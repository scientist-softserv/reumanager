class AddKindColumnToSnippets < ActiveRecord::Migration[5.2]
  def change
    add_column :snippets, :kind, :string
  end
end
