class ChangeSchooIdNotNull < ActiveRecord::Migration
  def change
    change_column_null :schools, :id, false
  end
end
