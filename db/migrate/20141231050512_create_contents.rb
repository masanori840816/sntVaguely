class CreateContents < ActiveRecord::Migration
  def change
    create_table :posts, id: false do |tblpost|
      tblpost.string :post_id
      tblpost.primary_key :post_id
      tblpost.string :post_title
      tblpost.string :post
      tblpost.timestamps
    end
    create_table :tags, id: false do |tbltags|
      tbltags.string :tag_id
      tbltags.primary_key :tag_id
      tbltags.string :tag_name
      tbltags.timestamps
    end
    create_table :taglinks do |tbltaglinks|
      tbltaglinks.integer :post_id
      tbltaglinks.integer :tag_id
    end
  end
end
