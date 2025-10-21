defmodule PingCRM.Core.Accounts.User do
  use PingCRM.Core.Schema

  alias PingCRM.Core.Repo
  alias PingCRM.Core.Accounts.Account

  schema "users" do
    belongs_to :account, Account
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string, virtual: true, redact: true
    field :password_hash, :string, redact: true
    field :role, Ecto.Enum, values: [:owner, :user]
    field :photo, :string

    timestamps()
    field :deleted_at, :utc_datetime_usec
  end

  def full_name(%__MODULE__{} = user) do
    "#{user.first_name} #{user.last_name}"
  end

  def changeset_create(user, attrs) do
    user
    |> Ecto.Changeset.cast(attrs, [:first_name, :last_name, :email, :password, :role, :photo])
    |> Ecto.Changeset.validate_required([:first_name, :last_name, :email, :password])
    |> Ecto.Changeset.validate_length(:first_name, max: 25)
    |> Ecto.Changeset.validate_length(:last_name, max: 25)
    |> validate_email()
    |> validate_password()
    |> Ecto.Changeset.validate_length(:photo, max: 100)
  end

  def changeset_update(user, attrs) do
    user
    |> Ecto.Changeset.cast(attrs, [:first_name, :last_name, :email, :password, :role, :photo])
    |> Ecto.Changeset.validate_required([:first_name, :last_name, :email])
    |> Ecto.Changeset.validate_length(:first_name, max: 25)
    |> Ecto.Changeset.validate_length(:last_name, max: 25)
    |> validate_email()
    |> validate_password()
    |> Ecto.Changeset.validate_length(:photo, max: 100)
  end

  # the regex is extracted from https://github.com/maennchen/email_checker
  @email_regex ~S"""
               ^(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?<domain>(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\]))$
               """
               |> String.trim()
               |> Regex.compile!([:caseless])
  defp validate_email(changeset) do
    changeset
    |> Ecto.Changeset.validate_format(:email, @email_regex)
    |> Ecto.Changeset.validate_length(:email, max: 50)
    |> Ecto.Changeset.unsafe_validate_unique(:email, Repo)
    |> Ecto.Changeset.unique_constraint(:email)
  end

  defp validate_password(changeset) do
    changeset
    |> Ecto.Changeset.validate_length(:password, min: 12, max: 72)
    |> maybe_hash_password()
  end

  defp maybe_hash_password(changeset) do
    password = Ecto.Changeset.get_change(changeset, :password)

    if password && changeset.valid? do
      changeset
      # Hashing could be done with `Ecto.Changeset.prepare_changes/2`, but that
      # would keep the database transaction open longer and hurt performance.
      |> Ecto.Changeset.put_change(:password_hash, Argon2.hash_pwd_salt(password))
      |> Ecto.Changeset.delete_change(:password)
    else
      changeset
    end
  end
end
