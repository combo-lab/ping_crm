defmodule PingCRM.Core.Accounts.UserPhotos do
  alias PingCRM.Core.Accounts.User

  # Hardcode it to match the path of Plug.Static in PingCRM.Web.Endpoint,
  # but it's ok.
  @plug_static_from Application.app_dir(:ping_crm, "priv/static")

  @upload_path "uploads/user_photos"
  @target_root Path.join(@plug_static_from, @upload_path)

  def store!(%User{} = user, %Plug.Upload{} = upload) do
    %{filename: filename, path: path} = upload
    extname = filename |> Path.extname() |> String.downcase()
    target_file = "#{user.id}#{extname}"
    target_path = Path.join(@target_root, target_file)

    File.mkdir_p!(@target_root)
    File.cp!(path, target_path)

    target_file
  end

  def fetch_url!(nil), do: nil
  def fetch_url!(target_file), do: Path.join(["/", @upload_path, target_file])
end
