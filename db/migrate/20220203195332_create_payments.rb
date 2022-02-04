class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.references :origin, null: false, foreign_key: { to_table: :users }
      t.references :target, null: false, foreign_key: { to_table: :users }
      t.integer    :amount, null: false, default: 0
      t.string     :description, null: true

      t.timestamps
    end
  end
end
