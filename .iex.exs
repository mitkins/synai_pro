alias SynaiPro.Accounts
alias SynaiPro.Accounts.User
alias SynaiPro.Accounts.UserNotifier
alias SynaiPro.Accounts.UserQuery
alias SynaiPro.Accounts.UserSeeder
alias SynaiPro.Accounts.UserSeeder
alias SynaiPro.Logs
alias SynaiPro.Logs.Log
alias SynaiPro.MailBluster
alias SynaiPro.Orgs
alias SynaiPro.Orgs.Invitation
alias SynaiPro.Orgs.Membership
alias SynaiPro.Repo
alias SynaiPro.Slack

# Don't cut off inspects with "..."
IEx.configure(inspect: [limit: :infinity])

# Allow copy to clipboard
# eg:
#    iex(1)> Phoenix.Router.routes(SynaiProWeb.Router) |> Helpers.copy
#    :ok
defmodule Helpers do
  def copy(term) do
    text =
      if is_binary(term) do
        term
      else
        inspect(term, limit: :infinity, pretty: true)
      end

    port = Port.open({:spawn, "pbcopy"}, [])
    true = Port.command(port, text)
    true = Port.close(port)

    :ok
  end
end
