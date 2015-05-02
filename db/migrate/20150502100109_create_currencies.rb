class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies, id: :uuid do |t|
      t.json :rates

      t.timestamps
    end
  end
end
