module ForemanTheme

  module OverrideAssets

    class DirectiveProcessor < Sprockets::DirectiveProcessor
      def process_include_foreman_directive(file_name)
        process_include_directive("#{Rails.root.to_s}/app/assets/#{file_name}")
      end
    end

    end
end