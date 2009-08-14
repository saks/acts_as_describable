class ActsAsDescribableGenerator < Rails::Generator::NamedBase
	attr_accessor :migration_name, :table_name, :model_name

  def manifest
		@migration_name = "Create#{class_name}Descriptions"
    @table_name = "#{name}_descriptions"
    @model_name = name

    record do |m|
      m.migration_template 'migration.rb',"db/migrate", :migration_file_name => "create_#{file_path}_descriptions"
    end
  end
end

