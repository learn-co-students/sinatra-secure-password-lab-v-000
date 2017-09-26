class ChangeColumnUserBalance < ActiveRecord::Migration

  def change
    change_table :users do |t|
      t.change :balance, :integer
    end
  end

end
