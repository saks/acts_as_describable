ActiveRecord::Schema.define(:version => 0) do
  create_table :sites, :force => true do |t|
    t.string :name
  end
  create_table :site_descriptions, :force => true, :id => false do |t|
    t.string :short_text
    t.text :long_text
    t.string :locale, :limit => 2
    t.belongs_to :model
  end

  execute "ALTER TABLE `rails_plugin_test`.`site_descriptions` ADD PRIMARY KEY ( `model_id` , `locale` )"
end

