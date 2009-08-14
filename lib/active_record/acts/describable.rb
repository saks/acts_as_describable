# ActsAsDescribable# HasForeignLanguage
module ActiveRecord
  module Acts #:nodoc:
    module Describable #:nodoc:

      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
      end

      module ClassMethods
        def acts_as_describable(options = {})
            include ActiveRecord::Acts::Describable
        end
      end#ClassMethods

			def description(options = {})
				case options
					when Symbol
						option, options = options, {}
						options[option.to_s.size > 2 ? :form : :locale] = option
				end
				options = {:form => :short, :locale => I18n.locale}.update options

				validate_locale options[:locale]
				validate_form options[:form]

				connection.select_value("
					select
						#{options[:form].to_s}_text
					from
						#{contruct_table_name}
					where
						locale = '#{options[:locale]}' and
						model_id = #{self.id}
					".squish) || ''
			end

			def set_description!(form, locale, text)

				validate_form form
				validate_locale locale

				connection.execute "INSERT INTO #{contruct_table_name}
					SET
						#{form}_text = '#{text}',
						model_id = #{self.id},
						locale = '#{locale}'
					ON DUPLICATE KEY UPDATE
						#{form}_text = '#{text}'
				".squish
			end

			private

			def validate_form(form)
				error "Unknown description form ``#{options[:form]}'',  must be :short, or :long" unless [:long, :short].include? form
			end

			def validate_locale(locale)
				error "Invalid locale ``#{locale}''" unless locale or locale.empty?
			end

			def error(text)
				raise ArgumentError, text
			end

			def contruct_table_name
				self.class.to_s.downcase + '_descriptions'
			end

    end#Describable
  end#Acts
end#ActiveRecord

