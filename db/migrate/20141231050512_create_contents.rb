class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |tblcontents|
      tblcontents.string :contentstitle
      tblcontents.string :contents
      tblcontents.timestamps
    end
    create_table :tags do |tbltags|
      tbltags.string :tagname
      tbltags.timestamps
    end
    create_table :taglinks do |tbltaglinks|
      tbltaglinks.string :contentsid
      tbltaglinks.string :tagid
    end    
  end
end
