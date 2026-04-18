defmodule Fairpr.Accounts.Student do
  use Ash.Resource,
    otp_app: :fairpr,
    domain: Fairpr.Accounts,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "students"
    repo Fairpr.Repo

    references do
      reference :current_therapist, on_delete: :nilify
    end
  end

  actions do
    defaults [:read, :destroy, create: :*]

    update :update do
      accept :*
      require_atomic? false
    end
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

  changes do
    change Fairpr.Accounts.Student.Changes.AssignHandle, on: [:create, :update]
  end

  attributes do
    uuid_primary_key :id

    attribute :first_name, :string do
      allow_nil? false
      public? true
    end

    attribute :middle_initial, :string do
      allow_nil? true
      public? true
    end

    attribute :last_name, :string do
      allow_nil? false
      public? true
    end

    attribute :birthday, :date do
      allow_nil? false
      public? true
    end

    attribute :intake_date, :date do
      allow_nil? false
      public? true
    end

    attribute :discharge_date, :date do
      allow_nil? true
      public? true
    end

    attribute :intake_grade, :integer do
      allow_nil? false
      public? true
    end

    attribute :current_grade, :integer do
      allow_nil? false
      public? true
    end

    attribute :handle, :string do
      allow_nil? false
      public? false
    end
  end

  relationships do
    belongs_to :current_therapist, Fairpr.Accounts.User do
      allow_nil? true
      public? true
    end
  end

  identities do
    identity :unique_name_and_birthday, [:first_name, :last_name, :birthday]
    identity :unique_handle, [:handle]
  end
end
