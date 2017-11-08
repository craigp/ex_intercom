defmodule ExIntercom.SegmentTest do

  @moduledoc false

  use ExUnit.Case
  alias ExIntercom.Segment

  setup do
    %{port: port} = bypass = Bypass.open
    Application.put_env(:ex_intercom, :api_url, "http://localhost:#{port}")
    {:ok, segment_json} = File.read("test/support/segment.json")
    {:ok,
      bypass: bypass,
      segment_json: segment_json
    }
  end

  test "fetches a segment by its ExIntercom ID", %{
    bypass: bypass,
    segment_json: segment_json
  } do
    id = "53203e244cba153d39000062"
    Bypass.expect bypass, fn %{
      request_path: request_path,
      query_string: query_string,
      method: method
    } = conn ->
      assert "/segments/#{id}" == request_path
      assert "" == query_string
      assert "GET" == method
      Plug.Conn.resp(conn, 200, segment_json)
    end
    {:ok, %Segment{
      id: id2,
      name: name
    }} = Segment.get(id)
    assert id == id2
    assert name == "New"
  end

end
