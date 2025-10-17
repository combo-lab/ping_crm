defmodule PingCRM.Core.Release do
  @moduledoc """
  Release-related tasks for production environment without Mix installed.

  ## Functions

  These module provides multiple public functions:

    * `migrate/_` - for migrating database structure.
    * `rollback/_` - for rolling back database structure.
    * `seed/_` - for seeding data.
    * `migrate_data/_` - for migrating data.

  ## Run a function manually

  Run the functions in this module by calling `eval` command provided by release.

  For example:

  ```sh
  $RELEASE_ROOT/bin/$RELEASE_NAME eval "PingCRM.Core.Release.migrate()"
  ```

  ## Run a function automatically

  For example, when starting a release:

  ```sh
  # mix release.init && $EDITOR rel/env.sh.eex
  case $RELEASE_COMMAND in
      start*)
          "$RELEASE_ROOT/bin/$RELEASE_NAME" eval "PingCRM.Core.Release.migrate()"
          ;;
      *)
          ;;
  esac
  ```

  Read more details and examples at:

    * https://hexdocs.pm/ecto_sql/3.13.2/Ecto.Migrator.html#module-example-running-migrations-in-a-release
    * https://hexdocs.pm/phoenix/1.8.1/releases.html#ecto-migrations-and-custom-commands

  """

  @app :ping_crm

  @doc """
  Migrate databases for all repos.

  ## Examples

      PingCRM.Core.Release.migrate()

  """
  def migrate do
    load_apps()

    for repo <- repos() do
      path = path_for_migrations(repo)
      up_for(repo, path, all: true)
    end
  end

  @doc """
  Migrate the database for a repo.

  It accepts the same `opts` of `Ecto.Migrator.run/4`.

  By deafult, `opts` is `[all: true]`.

  ## Examples

      PingCRM.Core.Release.migrate(PingCRM.Core.Repo)

  """
  def migrate(repo, opts \\ [all: true]) do
    load_apps()

    path = path_for_migrations(repo)
    up_for(repo, path, opts)
  end

  @doc """
  Rollback the database for a repo.

  It accepts the same `opts` of `Ecto.Migrator.run/4`.

  ## Examples

      PingCRM.Core.Release.rollback(PingCRM.Core.Repo)
      PingCRM.Core.Release.rollback(PingCRM.Core.Repo, step: 1)
      PingCRM.Core.Release.rollback(PingCRM.Core.Repo, to: 20250906120000)

  """
  def rollback(repo, opts \\ [step: 1]) do
    load_apps()

    path = path_for_migrations(repo)
    down_for(repo, path, opts)
  end

  @doc """
  Run seeds for a repo.

  When using `all: true` option, it expect a file which are located in
  `priv/repo/seeds.exs`. And, `priv/repo/seeds.exs` is free to call any seeds
  in `priv/repo/seeds/`. You can use this function as a batch operation for
  seeding `priv/repo/seeds/<name>.exs`.

  When using `name: name` option, it expects files which are located in
  `priv/repo/seeds/<name>.exs`.

  ## Example `priv/seeds.exs`

      [
        "foo.exs",
        "bar.exs",
        # ...
      ]
      |> Enum.each(fn file ->
        Code.eval_file(file, Path.join(__DIR__, "./seeds"))
      end)

  ## Examples

      PingCRM.Core.Release.seed(PingCRM.Core.Repo, all: true)
      PingCRM.Core.Release.seed(PingCRM.Core.Repo, name: "bar")

  """
  def seed(repo, opts \\ []) do
    load_apps()

    case opts do
      [all: true] ->
        seed_all(repo)

      [name: name] ->
        seed_one(repo, name)

      _ ->
        raise "I don't know what to do"
    end
  end

  defp seed_all(repo) do
    script = priv_path_for(repo, "seeds.exs")
    run_script(repo, script)
  end

  defp seed_one(repo, name) do
    script = priv_path_for(repo, "seeds/#{name}.exs")
    run_script(repo, script)
  end

  @doc """
  Run data migrations for a repo.

  When using `all: true` option, it expect a file which are located in
  `priv/repo/data_migrations.exs`. And, `priv/repo/data_migrations.exs` is free
  to call any data migraions in `priv/repo/data_migrations/`. You can use this
  function as a batch operation for seeding `priv/repo/data_migrations/<name>.exs`.

  When using `name: name` option, it expects files which are located in
  `priv/repo/data_migrations/<name>.exs`.

  ## Example `priv/<namespace>/data_migrations.exs`

      [
        "foo.exs",
        "bar.exs",
        # ...
      ]
      |> Enum.each(fn file ->
        Code.eval_file(file, Path.join(__DIR__, "./seeds"))
      end)

  ## Examples

      PingCRM.Core.Release.migrate_data(PingCRM.Core.Repo, all: true)
      PingCRM.Core.Release.migrate_data(PingCRM.Core.Repo, name: "bar")

  """
  def migrate_data(repo, opts \\ []) do
    load_apps()

    case opts do
      [all: true] ->
        migrate_all_data(repo)

      [name: name] ->
        migrate_one_data(repo, name)

      _ ->
        raise "I don't know what to do"
    end
  end

  defp migrate_all_data(repo) do
    script = priv_path_for(repo, "data_migrations.exs")
    run_script(repo, script)
  end

  defp migrate_one_data(repo, name) do
    script = priv_path_for(repo, "data_migrations/#{name}.exs")
    run_script(repo, script)
  end

  defp load_apps() do
    # Some platforms require SSL when connecting to the database
    Application.ensure_all_started(:ssl)
    Application.ensure_loaded(@app)
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp path_for_migrations(repo) do
    Ecto.Migrator.migrations_path(repo)
  end

  defp up_for(repo, path, opts) do
    {:ok, _, _} =
      Ecto.Migrator.with_repo(repo, fn repo ->
        Ecto.Migrator.run(repo, path, :up, opts)
      end)
  end

  defp down_for(repo, path, opts) do
    {:ok, _, _} =
      Ecto.Migrator.with_repo(repo, fn repo ->
        Ecto.Migrator.run(repo, path, :down, opts)
      end)
  end

  defp run_script(repo, path) do
    {:ok, fun_return, _} =
      Ecto.Migrator.with_repo(repo, fn _repo ->
        if File.exists?(path) do
          {result, _binding} = Code.eval_file(path)
          result
        else
          {:error, :bad_path, path}
        end
      end)

    fun_return
  end

  def priv_path_for(repo, filename) do
    Ecto.Migrator.migrations_path(repo, filename)
  end
end
