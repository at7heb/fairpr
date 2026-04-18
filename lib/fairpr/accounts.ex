defmodule Fairpr.Accounts do
  use Ash.Domain,
    otp_app: :fairpr

  resources do
    resource Fairpr.Accounts.Token

    resource Fairpr.Accounts.User do
      define :update_user, action: :update
    end

    resource Fairpr.Accounts.Role do
      define :create_role, action: :create
      define :list_roles, action: :read
      define :get_role_by_name, action: :read, get_by: [:name]
    end

    resource Fairpr.Accounts.UserRole

    resource Fairpr.Accounts.Student do
      define :list_students, action: :read
      define :get_student, action: :read, get_by: [:id]
      define :create_student, action: :create
      define :update_student, action: :update
    end
  end
end
