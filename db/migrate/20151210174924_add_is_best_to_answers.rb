class AddIsBestToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :is_best, :boolean, default: false
  end
end
