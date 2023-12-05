# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SynaiPro.Repo.insert!(%SynaiPro.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias SynaiPro.Accounts.User
alias SynaiPro.Accounts.UserSeeder
alias SynaiPro.Accounts.UserToken
alias SynaiPro.Accounts.UserTOTP
alias SynaiPro.Logs.Log
alias SynaiPro.Orgs.Org
alias SynaiPro.Orgs.OrgSeeder

alias SynaiPro.Orgs.Invitation
alias SynaiPro.Orgs.Membership

if Mix.env() == :dev do
  SynaiPro.Repo.delete_all(Log)
  SynaiPro.Repo.delete_all(UserTOTP)
  SynaiPro.Repo.delete_all(Invitation)
  SynaiPro.Repo.delete_all(Membership)
  SynaiPro.Repo.delete_all(Org)
  SynaiPro.Repo.delete_all(UserToken)
  SynaiPro.Repo.delete_all(User)

  admin = UserSeeder.admin()

  normal_user =
    UserSeeder.normal_user(%{
      email: "user@example.com",
      name: "Sarah Cunningham",
      password: "password",
      confirmed_at: Timex.to_naive_datetime(Timex.now())
    })

  org = OrgSeeder.random_org(admin)
  SynaiPro.Orgs.create_invitation(org, %{email: normal_user.email})

  UserSeeder.random_users(20)

  alias NimbleCSV.RFC4180, as: CSV

  # Lazily parses a file stream
  "priv/repo/blog_data_and_embeddings.csv"
  |> File.stream!
  |> CSV.parse_stream()
  |> Stream.map(fn [title, content, url, tokens, embedding] ->
    attrs = %{
      title: title,
      content: content,
      url: url,
      tokens: String.to_integer(tokens),
      embedding: Jason.decode!(embedding)
    }

    {:ok, _} = SynaiPro.Search.create_embedding(attrs)
  end)
  |> Stream.run()

end
