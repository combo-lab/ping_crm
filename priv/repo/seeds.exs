# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     alias PingCRM.Core.Repo
#     alias PingCRM.Core.SomeSchema
#
#     Repo.insert!(%SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PingCRM.Core.Repo
alias PingCRM.Core.Accounts
alias PingCRM.Core.Accounts.Account
alias PingCRM.Core.CRM

# remove all existing data using PostgreSQL's ON DELETE CASCADE

Repo.delete_all(Account)

# seed accounts

{:ok, account} = Accounts.create_account(%{name: "Acme Corporation"})

{:ok, _user} =
  Accounts.create_user(account, %{
    first_name: "John",
    last_name: "Doe",
    email: "johndoe@example.com",
    password: "secret!secret!",
    role: "owner"
  })

for _ <- 1..5 do
  {:ok, _user} =
    Accounts.create_user(account, %{
      first_name: Fake.Person.first_name(),
      last_name: Fake.Person.last_name(),
      email: Fake.Internet.safe_email(),
      password: Fake.String.base64(12),
      role: "user"
    })
end

# seed CRM

orgs =
  for _ <- 1..100 do
    {:ok, org} =
      CRM.create_org(account, %{
        name: Fake.Company.name(),
        email: Fake.Internet.safe_email(),
        phone: Fake.Phone.EnUs.phone(),
        address: Fake.Address.street_address(),
        city: Fake.Address.city(),
        region: Fake.Address.state(),
        country: "US",
        postal_code: Fake.Address.postcode()
      })

    org
  end

for _ <- 1..100 do
  org = Enum.random(orgs)

  {:ok, _contact} =
    CRM.create_contact(account, org, %{
      first_name: Fake.Person.first_name(),
      last_name: Fake.Person.last_name(),
      email: Fake.Internet.safe_email(),
      phone: Fake.Phone.EnUs.phone(),
      address: Fake.Address.street_address(),
      city: Fake.Address.city(),
      region: Fake.Address.state(),
      country: "US",
      postal_code: Fake.Address.postcode()
    })
end
