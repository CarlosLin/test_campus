class AddAddressColumnInSchool < ActiveRecord::Migration
  def change
	  add_column :schools, :address, :string, null: false
  end
end
