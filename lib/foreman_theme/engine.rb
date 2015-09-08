require 'deface'

module ForemanTheme

  class Engine < ::Rails::Engine
    engine_name 'foreman_theme'

    # Add any db migrations
    initializer "foreman_theme.load_app_instance_data" do |app|
      app.config.paths['db/migrate'] += ForemanTheme::Engine.paths['db/migrate'].existent
    end

    initializer 'foreman_theme.register_plugin', :after=> :finisher_hook do |app|
      Foreman::Plugin.register :foreman_theme do
        requires_foreman '>= 1.4'

        # Add permissions
        security_block :foreman_theme do
          permission :view_foreman_theme, {:'foreman_theme/hosts' => [:new_action] }
        end

        # Add a new role called 'Discovery' if it doesn't exist
        role "ForemanTheme", [:view_foreman_theme]

        #add menu entry
        menu :top_menu, :template,
             :url_hash => {:controller => :'foreman_theme/hosts', :action => :new_action },
             :caption  => 'ForemanTheme',
             :parent   => :hosts_menu,
             :after    => :hosts

        # add dashboard widget
        widget 'foreman_theme_widget', :name=>N_('Foreman plugin template widget'), :sizex => 4, :sizey =>1

      end
    end

    # Precompile any JS or CSS files under app/assets/
    # If requiring files from each other, list them explicitly here to avoid precompiling the same
    # content twice.
    assets_to_precompile =
      Dir.chdir(root) do
        Dir['app/assets/javascripts/**/*', 'app/assets/stylesheets/**/*'].map do |f|
          f.split(File::SEPARATOR, 4).last
        end
      end
    initializer 'foreman_theme.assets.precompile' do |app|
      app.config.assets.precompile += assets_to_precompile
    end
    initializer 'foreman_theme.configure_assets', :group => :assets do
      SETTINGS[:foreman_theme] = {:assets => {:precompile => assets_to_precompile}}

      assets_to_override =
        Dir.chdir(root) do
          Dir['app/assets/**/*'].map do |f|
            f.split(File::SEPARATOR, 4).last
          end
        end
      Rails.application.assets.prepend_path assets_to_override
    end

    initializer 'foreman_theme.override_assets' do |app|
      assets_to_override =
        Dir.chdir(Gem.loaded_specs['foreman_theme'].full_gem_path) do
          Dir['app/assets/**'].map { |d| File.absolute_path d }
        end
      assets_to_override.each { |path| app.assets.prepend_path path }
    end


    #Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, ForemanTheme::HostExtensions)
        HostsHelper.send(:include, ForemanTheme::HostsHelperExtensions)
      rescue => e
        puts "ForemanTheme: skipping engine hook (#{e.to_s})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanTheme::Engine.load_seed
      end
    end

    initializer 'foreman_theme.register_gettext', :after => :load_config_initializers do |app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_theme'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end

    initializer 'foreman_theme.overrides' do |app|
      # pre pending plugin path to the sass @import method in order for it to search foreman_theme for files before it does it in the local dir
      Rails.application.config.sass.load_paths << "#{config.root}/app/assets/stylesheets"

      #adding the override method "include_foreman" to sprockets engine
      require "directive_processor"
      Sprockets::DirectiveProcessor.send :include, ForemanTheme::OverrideAssets::DirectiveProcessor
      Rails.application.assets.unregister_processor('text/css', Sprockets::DirectiveProcessor)
      Rails.application.assets.unregister_processor('application/javascript', Sprockets::DirectiveProcessor)
      # registering the new engine override
      Rails.application.assets.register_processor('text/css', ForemanTheme::OverrideAssets::DirectiveProcessor)
      Rails.application.assets.register_processor('application/javascript', ForemanTheme::OverrideAssets::DirectiveProcessor)
    end

  end

end
