defmodule Intercom.AdminTest do

  @moduledoc false

  use ExUnit.Case
  alias Intercom.Admin

  setup do
    %{port: port} = bypass = Bypass.open
    Application.put_env(:intercom, :api_url, "http://localhost:#{port}")
    {:ok, admin_json} = File.read("test/support/admin.json")
    {:ok,
      bypass: bypass,
      admin_json: admin_json
    }
  end

  test "fetches a admin by its Intercom ID", %{
    bypass: bypass,
    admin_json: admin_json
  } do
    id = "1"
    Bypass.expect bypass, fn %{
      request_path: request_path,
      query_string: query_string,
      method: method
    } = conn ->
      assert "/admins/#{id}" == request_path
      assert "" == query_string
      assert "GET" == method
      Plug.Conn.resp(conn, 200, admin_json)
    end
    {:ok, %Admin{
      id: id2,
      name: name
    }} = Admin.get(id)
    assert id == id2
    assert name == "Hoban Washburne"
  end

end
