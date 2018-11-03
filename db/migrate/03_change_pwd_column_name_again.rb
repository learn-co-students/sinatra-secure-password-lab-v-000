class ChangePwdColumnNameAgain < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.rename :password_hash, :password_digest
    end
  end
end
