# create users with relationships
3.times do
  user = FactoryBot.create(:user)
  user.friends << FactoryBot.create_list(:user, 2)
end
