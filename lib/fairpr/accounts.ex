defmodule Fairpr.Accounts do
  use Ash.Domain,
    otp_app: :fairpr

  resources do
    resource Fairpr.Accounts.Token
    resource Fairpr.Accounts.User
  end
end
