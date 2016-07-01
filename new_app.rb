puts "Template for a new rails application"

install_bootstrap = yes?("Install Bootstrap?")

gem_group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'letter_opener'
  gem 'annotate', github: 'ctran/annotate_models'
end

gem "haml-rails"
gem "mc-settings"
gem 'workflow', github: 'geekq/workflow'



if install_bootstrap
    gem 'bootstrap-sass'
    gem 'autoprefixer-rails'
    gem "bootstrap_flash_messages"
end





after_bundle do

    # load lib stuff
    environment "config.autoload_paths << Rails.root.join('lib')"
    

    #install initalizer for mc settings
    initializer '01_mc_settings.rb',
        'Setting.load(:path  => "#{Rails.root}/config/settings",
                 :files => ["default.yml", "environments/#{Rails.env}.yml"],
                 :local => true)'
   

    file 'config/settings/default.yml', 
      'main:'
    

    #letter opener
    environment 'config.action_mailer.delivery_method = :letter_opener', env: 'development'

    #delete old gitignore
    run("rm .gitignore")
    #create new gitignore
    file '.gitignore', <<-CODE
# See https://help.github.com/articles/ignoring-files for more about ignoring files.
#
# If you find yourself ignoring temporary files generated by your text editor
# or operating system, you probably want to add a global ignore instead:
#   git config --global core.excludesfile '~/.gitignore_global'

# Ignore bundler config.
/.bundle

# Ignore the default SQLite database.
/db/*.sqlite3
/db/*.sqlite3-journal

# Ignore all logfiles and tempfiles.
/log/*.log
/tmp

#mac generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes

.idea/

/config/database.yml
    CODE



    # haml rails stuff
    generate("haml:application_layout convert")
    run("rm app/views/layouts/application.html.erb")

    #annotate
    generate("annotate:install")

    if install_bootstrap
        #create application.scss
        file 'app/assets/stylesheets/application.scss', <<-CODE
/*
* This is a manifest file that'll be compiled into application.css, which will include all the files
* listed below.
*
* Any CSS and SCSS file within this directory, lib/assets/stylesheets, vendor/assets/stylesheets,
* or vendor/assets/stylesheets of plugins, if any, can be referenced here using a relative path.
*
* You're free to add application-wide styles to this file and they'll appear at the bottom of the
* compiled file so the styles you add here take precedence over styles defined in any styles
* defined in the other CSS/SCSS files in this directory. It is generally better to create a new
* file per style scope.
*
*= require jquery-ui
*= require_tree .
*= require_self
*/

// "bootstrap-sprockets" must be imported before "bootstrap" and "bootstrap/variables"
@import "bootstrap-sprockets";
@import "bootstrap";
        CODE
        #remove old apllication.css
        run("rm app/assets/stylesheets/application.css")

        #remove old application.js
        run("rm app/assets/javascripts/application.js")
        #create new application.js
        file 'app/assets/javascripts/application.js', <<-CODE
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap-sprockets
//= require_tree .
        CODE
        
    end


end








