# create users with relationships
user1 = FactoryBot.create(:user, balance: 100)
user2 = FactoryBot.create(:user, balance: 200)
user3 = FactoryBot.create(:user, balance: 300)
user4 = FactoryBot.create(:user, balance: 400)
user5 = FactoryBot.create(:user, balance: 500)

user1.friends << user2
user1.friends << user3

user2.friends << user3
user2.friends << user4

user3.friends << user4

# user1 with its own payments
FactoryBot.create(:payment, origin: user1, target: user2, amount: 300)
FactoryBot.create(:payment, origin: user3, target: user1, amount: 350)

# user2 with its own payments
FactoryBot.create(:payment, origin: user2, target: user3, amount: 150)
FactoryBot.create(:payment, origin: user4, target: user2, amount: 200)

# user3 with its own payments
FactoryBot.create(:payment, origin: user3, target: user4, amount: 50)
FactoryBot.create(:payment, origin: user4, target: user3, amount: 250)

# user4 with its own payments
FactoryBot.create(:payment, origin: user4, target: user5, amount: 100)
FactoryBot.create_list(:payment, 100, origin: user4)
