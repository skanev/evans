# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'sass', :input => 'app/stylesheets', :output => 'public/stylesheets'

guard 'livereload' do
  watch(%r{app/.+\.(erb|haml)})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{app/assets/stylesheets/_.+\.scss}) { 'app/assets/application.css' }
  watch(%r{(app/assets/.+\.js)\.coffee}) { |m| m[1] }
  watch(%r{config/locales/.+\.yml})
end
