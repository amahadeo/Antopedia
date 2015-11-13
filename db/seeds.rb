require 'faker'

# Create Users
7.times do
  user = User.new(
    username: Faker::Internet.user_name,
    email:    Faker::Internet.email,
    password: '123456789'
  )
  user.skip_confirmation!
  user.save!
end

# Create test user
member = User.new(
  username: 'member1',
  email:    'member@antopedia.com',
  password: '123456789'
)
member.skip_confirmation!
member.save!

users = User.all

# Create wikis
50.times do
  Wiki.create!(
    title: Faker::Company.catch_phrase,
    body:  Faker::Lorem.paragraphs,
    user:  users.sample
  )
end

puts "Seed Finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
