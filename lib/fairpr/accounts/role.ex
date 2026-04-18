defmodule Fairpr.Accounts.Role do
  use Ash.Resource,
    otp_app: :fairpr,
    domain: Fairpr.Accounts,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "roles"
    repo Fairpr.Repo
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

    attribute :name, :string do
      allow_nil? false
      public? true
    end
  end

  relationships do
    many_to_many :users, Fairpr.Accounts.User do
      through Fairpr.Accounts.UserRole
      source_attribute_on_join_resource :role_id
      destination_attribute_on_join_resource :user_id
    end
  end

  identities do
    identity :unique_name, [:name]
  end
end
