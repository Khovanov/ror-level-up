class AddIndexProviderUidToAuthorizations < ActiveRecord::Migration
  def change
    add_index :authorizations, [:provider, :uid]
  end
end
