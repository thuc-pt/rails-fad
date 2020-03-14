# Examples:
# movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# Character.create(name: 'Luke', movie: movies.first)
User.create(
  role_id: 1,
  email: "ptthuc77@gmail.com",
  name: "Phan Trong Thuc",
  password: "123456",
  password_confirmation: "123456"
)

Payment.create([
  {name: "Payment on delivery"},
  {name: "ATM card"},
  {name: "Visa card"}
])

Category.create([
  {name: "Food"},
  {name: "Drink"},
  {name: "Fruit", parent_id: 1},
  {name: "Juice", parent_id: 2},
  {name: "Vegetable", parent_id: 1},
  {name: "Milk tea", parent_id: 2}
])
