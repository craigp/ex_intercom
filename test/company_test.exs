defmodule Intercom.CompanyTest do

  @moduledoc false

  use ExUnit.Case, async: true
  alias Intercom.Company

  setup do
    %{port: port} = bypass = Bypass.open
    Application.put_env(:intercom, :api_url, "http://localhost:#{port}")
    {:ok, company_json} = File.read("test/support/company.json")
    {:ok,
      bypass: bypass,
      company_json: company_json
    }
  end

  test "fetches a company by its Intercom ID", %{
    bypass: bypass,
    company_json: company_json
  } do
    id = "531ee472cce572a6ec000006"
    Bypass.expect bypass, fn %{
      request_path: request_path,
      query_string: query_string,
      method: method
    } = conn ->
      assert "/companies/#{id}" == request_path
      assert "" == query_string
      assert "GET" == method
      Plug.Conn.resp(conn, 200, company_json)
    end
    {:ok, %Company{
      id: id2,
      name: name
    }} = Company.get(id)
    assert id == id2
    assert name == "Blue Sun"
  end

end
