class CreateToots < ActiveRecord::Migration[5.2]
  def change
    create_table :toots do |t|
      t.references :instance, foreign_key: true
      t.string :language

      t.timestamps
    end
  end
end
