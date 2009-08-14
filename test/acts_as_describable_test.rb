require File.dirname(__FILE__) + '/test_helper'

class Site < ActiveRecord::Base
	acts_as_describable
end

class ActsAsDescribableTest < ActiveSupport::TestCase
  ActiveSupport::TestCase.load_schema

	def setup
		@short_en_text = 'short en description'
		@long_en_text = 'long en description'
		@short_ru_text = 'short ru description'
		@long_ru_text = 'long ru description'
		@long_be_text = 'long be description'

		@site = Site.create!
		I18n.locale = 'en'
	end

	test 'should return empty description if no any' do
		assert_equal '', @site.description
		assert_equal '', @site.description(:ru)
		assert_equal '', @site.description(:short)
		assert_equal '', @site.description(:long)
	end

	test 'should return short by default' do
		@site.set_description! :short, :en, @short_en_text
		@site.set_description! :long, :en, @long_en_text
		assert_equal @short_en_text, @site.description
	end

	test 'should return short or long as specified' do
		@site.set_description! :short, :en, @short_en_text
		@site.set_description! :long, :en, @long_en_text

		assert_equal @long_en_text, @site.description(:long)
		assert_equal @short_en_text, @site.description(:short)
	end

	test 'should return secified locale' do
		@site.set_description! :short, :en, @short_en_text
		@site.set_description! :short, :ru, @short_ru_text

		assert_equal(@short_ru_text, @site.description(:ru))
		assert_equal(@short_en_text, @site.description(:en))
	end

	test 'should return description as specified' do
		@site.set_description! :short, :en, @short_en_text
		@site.set_description! :long, :en, @long_en_text
		@site.set_description! :short, :ru, @short_ru_text
		@site.set_description! :long, :ru, @long_ru_text

		assert_equal @short_ru_text, @site.description(:form => :short, :locale => :ru)
		assert_equal @short_en_text, @site.description(:form => :short, :locale => :en)
		assert_equal @long_ru_text, @site.description(:form => :long, :locale => :ru)
		assert_equal @long_en_text, @site.description(:form => :long, :locale => :en)
	end

	test 'should return in default locale' do
		I18n.locale = 'ru'

		@site.set_description!(:short, :ru, @short_ru_text)
		assert_equal(@short_ru_text, @site.description)
	end

	test 'should return empty string for any description' do
		assert_equal '', @site.description(:any)
	end

	test 'should return any existing description' do
		@site.set_description! :long, :be, @long_be_text
		assert_equal @long_be_text, @site.description(:any)
	end

	test 'should prefer I18n locale for any description' do
		I18n.locale = 'be'
		@site.set_description! :long, :en, @long_en_text
		@site.set_description! :long, :be, @long_be_text
		assert_equal @long_be_text, @site.description(:any)
	end

	test 'should fail witout all parameters passed to set_description!' do
		assert_raise(ArgumentError) { @site.set_description! }
		assert_raise(ArgumentError) { @site.set_description! :short }
		assert_raise(ArgumentError) { @site.set_description! :short, :en }
		assert_raise(ArgumentError) { @site.set_description! :en, :short }
	end

	test 'should fail with invalid arguments passed to description' do
		assert_raise(ArgumentError) { @site.description(:qwe) }
		assert_raise(ArgumentError) { @site.description(:form => :invalid) }
		assert_raise(ArgumentError) { @site.description(:form => :short, :locale => '')}
	end

end

