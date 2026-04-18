defmodule Fairpr.Accounts.UserRole do
  use Ash.Resource,
    otp_app: :fairpr,
    domain: Fairpr.Accounts,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "user_roles"
    repo Fairpr.Repo

    references do
      reference :user, on_delete: :delete
      reference :role, on_delete: :delete
    end
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end

    policy action_type(:create) do
      authorize_if always()
    end

    policy action_type(:update) do
      authorize_if always()
    end

    policy action_type(:destroy) do
      authorize_if always()
    end
  end

  attributes do
    uuid_primary_key :id
  end

  relationships do
    belongs_to :user, Fairpr.Accounts.User do
      allow_nil? false
    end

    belongs_to :role, Fairpr.Accounts.Role do
      allow_nil? false
    end
  end

  identities do
    identity :unique_user_role, [:user_id, :role_id]
  end
end
