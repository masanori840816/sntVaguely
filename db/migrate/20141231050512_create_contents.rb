class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents, id: false do |tblcontents|
      tblcontents.string :contentsid
      tblcontents.primary_key :contentsid
      tblcontents.string :contentstitle
      tblcontents.string :contents
      tblcontents.timestamps
    end
    create_table :tags, id: false do |tbltags|
      tbltags.string :tagid
      tbltags.primary_key :tagid
      tbltags.string :tagname
      tbltags.timestamps
    end
    create_table :taglinks do |tbltaglinks|
      tbltaglinks.integer :contentsid
      tbltaglinks.integer :tagid
    end
  end
end
