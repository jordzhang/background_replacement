class CreatePresentations < ActiveRecord::Migration
  def change
    create_table :presentations do |t|
      t.string :video
      t.string :background

      t.timestamps
    end
  end
end
