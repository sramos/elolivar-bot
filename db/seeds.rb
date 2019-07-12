# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless Admin.any?
  admin = Admin.new( name: 'Default Admin',
                     email: 'admin@admin.es',
                     password: '123456789',
                     password_confirmation: '123456789'
                 )
  admin.skip_confirmation!
  admin.save!
end
