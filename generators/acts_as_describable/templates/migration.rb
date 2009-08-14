class <%= migration_name.underscore.camelize %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name -%>, {
			:force => true,
			:options => 'ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci',
			:id => false
  	} do |t|
  		t.string :short_text
  		t.text :long_text
  		t.integer :model_id
  		t.string :locale, :limit => 2
    end

    execute "ALTER TABLE <%= model_name -%>_descriptions ADD PRIMARY KEY ( `model_id` , `locale` ) "
  end

  def self.down
    drop_table(:<%= table_name -%>);
  end
end

