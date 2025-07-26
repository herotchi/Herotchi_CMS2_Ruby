# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Manager.find_or_create_by!(login_id: 'test1test1') do |manager|
  manager.email = 'test1@test.co.jp'
  manager.password = ENV.fetch('MANAGER1_PASSWORD')
  manager.password_confirmation = ENV.fetch('MANAGER1_PASSWORD')
end

Manager.find_or_create_by!(login_id: 'test2test2') do |manager|
  manager.email = 'test2@test.co.jp'
  manager.password = ENV.fetch('MANAGER2_PASSWORD')
  manager.password_confirmation = ENV.fetch('MANAGER2_PASSWORD')
end