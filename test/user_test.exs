defmodule Intercom.UserTest do

  @moduledoc false

  use ExUnit.Case
  alias Intercom.{User, Location, Avatar, Company, SocialProfile,
    Segment, Tag}

  setup do
    %{port: port} = bypass = Bypass.open
    Application.put_env(:intercom, :api_url, "http://localhost:#{port}")
    {:ok, user_json} = File.read("test/support/user.json")
    {:ok,
      bypass: bypass,
      user_json: user_json
    }
  end

  test "fetches a user by their Intercom ID", %{
    bypass: bypass,
    user_json: user_json
  } do
    id = "530370b477ad7120001d"
    Bypass.expect bypass, fn %{
      request_path: request_path,
      query_string: query_string,
      method: method
    } = conn ->
      assert "/users/#{id}" == request_path
      assert "" == query_string
      assert "GET" == method
      Plug.Conn.resp(conn, 200, user_json)
    end
    {:ok, %User{
      id: id2,
      avatar: %Avatar{
        image_url: avatar_image_url
      },
      location: %Location{
        city_name: city_name
      },
      social_profiles: [%SocialProfile{
        id: social_profile_id
      }|[]],
      companies: [%Company{
        id: company_id
      }|[]],
      segments: [%Segment{
        id: segment_id
      }|[]],
      tags: [%Tag{
        id: tag_id
      }]
    }} = User.get(id)
    assert id == id2
    assert company_id == "530370b477ad7120001e"
    assert social_profile_id == "1235d3213"
    assert avatar_image_url == "https://example.org/128Wash.jpg"
    assert city_name == "Dublin"
    assert tag_id == "202"
    assert segment_id == "5310d8e7598c9a0b24000002"
  end

  test "finds a user by their user ID", %{
    bypass: bypass,
    user_json: user_json
  } do
    user_id = "25"
    Bypass.expect bypass, fn %{
      request_path: request_path,
      query_string: query_string,
      method: method
    } = conn ->
      assert "/users" == request_path
      assert  URI.encode_query(%{user_id: user_id}) == query_string
      assert "GET" == method
      Plug.Conn.resp(conn, 200, user_json)
    end
    {:ok, %User{
      user_id: user_id2,
      avatar: %Avatar{
        image_url: avatar_image_url
      },
      location: %Location{
        city_name: city_name
      },
      social_profiles: [%SocialProfile{
        id: social_profile_id
      }|[]],
      companies: [%Company{
        id: company_id
      }|[]],
      segments: [%Segment{
        id: segment_id
      }|[]],
      tags: [%Tag{
        id: tag_id
      }]
    }} = User.find({:user_id, user_id})
    assert user_id == user_id2
    assert company_id == "530370b477ad7120001e"
    assert social_profile_id == "1235d3213"
    assert avatar_image_url == "https://example.org/128Wash.jpg"
    assert city_name == "Dublin"
    assert tag_id == "202"
    assert segment_id == "5310d8e7598c9a0b24000002"
  end

  test "finds a user by their email address", %{
    bypass: bypass,
    user_json: user_json
  } do
    email = "wash@serenity.io"
    Bypass.expect bypass, fn %{
      request_path: request_path,
      query_string: query_string,
      method: method
    } = conn ->
      assert "/users" == request_path
      assert URI.encode_query(%{email: email}) == query_string
      assert "GET" == method
      Plug.Conn.resp(conn, 200, user_json)
    end
    {:ok, %User{
      email: email2,
      avatar: %Avatar{
        image_url: avatar_image_url
      },
      location: %Location{
        city_name: city_name
      },
      social_profiles: [%SocialProfile{
        id: social_profile_id
      }|[]],
      companies: [%Company{
        id: company_id
      }|[]],
      segments: [%Segment{
        id: segment_id
      }|[]],
      tags: [%Tag{
        id: tag_id
      }]
    }} = User.find({:email, email})
    assert email == email2
    assert company_id == "530370b477ad7120001e"
    assert social_profile_id == "1235d3213"
    assert avatar_image_url == "https://example.org/128Wash.jpg"
    assert city_name == "Dublin"
    assert tag_id == "202"
    assert segment_id == "5310d8e7598c9a0b24000002"
  end

end
