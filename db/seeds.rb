# Examples:
# movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# Character.create(name: 'Luke', movie: movies.first)
User.create([
  {role_id: 1,
  email: "thucpt@gmail.com",
  name: "Phan Trong Thuc",
  password: "123456",
  password_confirmation: "123456",
  confirmed_at: Date.current},
  {role_id: 2,
  email: "example01@gmail.com",
  name: "Example 01",
  password: "123456",
  password_confirmation: "123456",
  confirmed_at: Date.current},
  {role_id: 2,
  email: "example02@gmail.com",
  name: "Example 02",
  password: "123456",
  password_confirmation: "123456",
  confirmed_at: Date.current},
  {role_id: 2,
  email: "example03@gmail.com",
  name: "Example 03",
  password: "123456",
  password_confirmation: "123456",
  confirmed_at: Date.current},
  {role_id: 2,
  email: "example04@gmail.com",
  name: "Example 04",
  password: "123456",
  password_confirmation: "123456",
  confirmed_at: Date.current}
])

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
