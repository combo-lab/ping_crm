defmodule PingCRM.Web.ErrorHTMLTest do
  use PingCRM.Web.ConnCase, async: true

  import Combo.Template, only: [render_to_string: 4]
  alias PingCRM.Web.ErrorHTML

  test "renders 404.html" do
    assert render_to_string(ErrorHTML, "404", "html", []) =~ "Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(ErrorHTML, "500", "html", []) =~ "Internal Server Error"
  end
end
