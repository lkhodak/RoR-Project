#encoding: utf-8
I18n.load_path += Dir[Rails.root.join('lib', 'locales', '*.{rb,yml}')]
I18n.default_locale = :uk
LANGUAGES=[
    ['English', 'en'],
    ['Українська','uk']
]