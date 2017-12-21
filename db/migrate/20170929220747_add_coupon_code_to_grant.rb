class AddCouponCodeToGrant < ActiveRecord::Migration[5.1]
  def change
    add_column :grants, :coupon_code, :string
  end
end
