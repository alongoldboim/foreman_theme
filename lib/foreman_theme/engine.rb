require 'deface'

module ForemanTheme

  class Engine < ::Rails::Engine
    engine_name 'foreman_theme'
    config.autoload_paths += Dir["#{config.root}/app/overrides"]
    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    engine_peth = config.root
    # Add any db migrations
    initializer "foreman_theme.load_app_instance_data" do |app|
      app.config.paths['db/migrate'] += ForemanTheme::Engine.paths['db/migrate'].existent
    end

    assets_to_precompile =
        Dir.chdir(root) do
          Dir['app/assets/javascripts/**/*', 'app/assets/stylesheets/**/*'].map do |f|
            f.split(File::SEPARATOR, 4).last
          end
        end
    initializer 'foreman_theme.assets.precompile' do |app|
      app.config.assets.precompile += assets_to_precompile
    end

    initializer 'foreman_theme.override_assets' do |app|
      unless Rails.env.production?
        assets_to_override =
            Dir.chdir(Gem.loaded_specs['foreman_theme'].full_gem_path) do
              Dir['app/assets/**'].map { |d| File.absolute_path d }
            end
        assets_to_override.each { |path| app.assets.prepend_path path }
      end
    end

    initializer 'foreman_theme.register_plugin', :after=> :finisher_hook do |app|
      Foreman::Plugin.register :foreman_theme do
        requires_foreman '>= 1.4'

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
      unless Rails.env.production?
        assets_to_override =
        Dir.chdir(Gem.loaded_specs['foreman_theme'].full_gem_path) do
          Dir['app/assets/**'].map { |d| File.absolute_path d }
        end
      assets_to_override.each { |path| app.assets.prepend_path path }
      end
    end


    #Include concerns in this config.to_prepare block
    config.to_prepare do
      assets_to_override = [
          "#{engine_peth}/app/assets/stylesheets",
          "#{engine_peth}/app/assets/images",
          "#{engine_peth}/app/assets/javascripts"]
      assets_to_override.each { |path| Rails.application.config.assets.paths.unshift path }
      require "directive_processor"
      Rails.application.assets.unregister_processor('text/css', Sprockets::DirectiveProcessor)
      Rails.application.assets.unregister_processor('application/javascript', Sprockets::DirectiveProcessor)
      # registering the new engine override
      Rails.application.assets.register_processor('text/css', ForemanTheme::OverrideAssets::DirectiveProcessor)
      Rails.application.assets.register_processor('application/javascript', ForemanTheme::OverrideAssets::DirectiveProcessor)
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

  end

end
