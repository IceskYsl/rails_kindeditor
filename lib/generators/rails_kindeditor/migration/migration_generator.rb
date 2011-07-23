module RailsKindeditor
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)
    desc "Copy migration to your application."      
    class_option :orm, :type => :string, :aliases => "-o", :default => "active_record",
     :desc => "Orm for rails,'active_record' or 'mongoid'."

     def copy_app 
       copy_controller
       copy_model
       copy_uploaders
     end

   def self.next_migration_number(dirname)
     if ActiveRecord::Base.timestamped_migrations
       Time.now.utc.strftime("%Y%m%d%H%M%S")
     else
       "%.3d" % (current_migration_number(dirname) + 1)
     end
   end
   
   protected 
   def copy_uploaders
    template 'app/uploaders/kindeditor/file_uploader.rb',"app/uploaders/kindeditor/file_uploader.rb" 
    template 'app/uploaders/kindeditor/image_uploader.rb',"app/uploaders/kindeditor/image_uploader.rb" 
   end
   
   def copy_controller
    template 'app/controllers/kindeditor/assets_controller.rb',"app/controllers/kindeditor/assets_controller.rb"
   end

   def copy_model   
     case options[:orm].to_s
     when "active_record"
       template 'app/models/kindeditor/asset.rb',"app/models/kindeditor/asset.rb" 
       template 'app/models/kindeditor/file.rb',"app/models/kindeditor/file.rb" 
       template 'app/models/kindeditor/image.rb',"app/models/kindeditor/image.rb" 
       copy_migration
     when "mongoid"                                                           
       template 'mongoid/kindeditor/asset.rb','app/models/kindeditor/asset.rb'
       template 'mongoid/kindeditor/file.rb','app/models/kindeditor/file.rb'
       template 'mongoid/kindeditor/image.rb','app/models/kindeditor/image.rb'
     end
   end   
   
   def copy_migration
     migration_template "migration/migration.rb", "db/migrate/create_kindeditor_assets.rb"
   end
  end
end

