defmodule Support.Factory do
  @moduledoc false

  use ExMachina.Ecto

  alias Support.Randoms

  alias ChatDb.Schemas.Attachment
  alias ChatDb.Schemas.Chat
  alias ChatDb.Schemas.Handle
  alias ChatDb.Schemas.Message

  def chat_factory do
    build(:random_chat)
  end

  def attachment_factory do
    build(:random_attachment)
  end

  def handle_factory do
    build(:random_handle)
  end

  def message_factory do
    build(:random_message)
  end

  def random_chat_factory do
    %Chat{
      account_id: Randoms.random(:account_id, :string),
      account_login: Randoms.random(:account_login, :string),
      chat_identifier: Randoms.random(:chat_identifier, :string),
      display_name: Randoms.random(:display_name, :string),
      group_id: Randoms.random(:group_id, :string),
      guid: Randoms.random(:guid, :string),
      is_archived: Randoms.random(:boolean_int),
      is_filtered: Randoms.random(:boolean_int),
      last_addressed_handle: Randoms.random(:last_addressed_handle, :string),
      properties: Randoms.random(:properties, :binary),
      room_name: Randoms.random(:room_name, :string),
      service_name: Randoms.random(:service_name, :string),
      state: Randoms.random(:state, :integer),
      style: Randoms.random(:style, :integer),
      successful_query: Randoms.random(:boolean_int)
    }
  end

  def random_attachment_factory do
    %Attachment{
      created_date: Randoms.random(:created_date, :utc_datetime_usec),
      filename: Randoms.random(:filename, :string),
      guid: Randoms.random(:guid, :string),
      is_outgoing: Randoms.random(:is_outgoing, :integer),
      mime_type: Randoms.random(:mime_type, :string),
      start_date: Randoms.random(:start_date, :utc_datetime_usec),
      total_bytes: Randoms.random(:total_bytes, :integer),
      transfer_name: Randoms.random(:transfer_name, :string),
      transfer_state: Randoms.random(:transfer_state, :integer),
      user_info: Randoms.random(:user_info, :binary),
      uti: Randoms.random(:uti, :string)
    }
  end

  def random_handle_factory do
    %Handle{
      country: Randoms.random(:country, :string),
      id: Randoms.random(:id, :string),
      service: Randoms.random(:service, :string),
      uncanonicalized_id: Randoms.random(:uncanonicalized_id, :string)
    }
  end

  def random_message_factory do
    %Message{
      rowid: Randoms.random(:primary_key),
      is_from_me: Randoms.random(:is_from_me, :boolean_int),
      is_audio_message: Randoms.random(:is_audio_message, :boolean_int),
      service: Randoms.random(:service, :string),
      subject: Randoms.random(:subject, :string),
      is_delayed: Randoms.random(:is_delayed, :boolean_int),
      guid: Randoms.random(:guid, :string),
      group_title: Randoms.random(:group_title, :string),
      has_dd_results: Randoms.random(:has_dd_results, :integer),
      account: Randoms.random(:account, :string),
      date_read: Randoms.random(:date_read, :integer),
      is_sent: Randoms.random(:is_sent, :boolean_int),
      country: Randoms.random(:country, :string),
      item_type: Randoms.random(:item_type, :integer),
      is_delivered: Randoms.random(:is_delivered, :boolean_int),
      type: Randoms.random(:type, :integer),
      is_auto_reply: Randoms.random(:is_auto_reply, :boolean_int),
      service_center: Randoms.random(:service_center, :string),
      is_expirable: Randoms.random(:is_expirable, :boolean_int),
      is_played: Randoms.random(:is_played, :boolean_int),
      date_delivered: Randoms.random(:date_delivered, :integer),
      was_deduplicated: Randoms.random(:was_deduplicated, :integer),
      was_data_detected: Randoms.random(:was_data_detected, :integer),
      error: Randoms.random(:error, :integer),
      date_played: Randoms.random(:date_played, :integer),
      was_downgraded: Randoms.random(:was_downgraded, :integer),
      message_source: Randoms.random(:message_source, :integer),
      account_guid: Randoms.random(:account_guid, :string),
      replace: Randoms.random(:replace, :integer),
      is_service_message: Randoms.random(:is_service_message, :boolean_int),
      cache_roomnames: Randoms.random(:cache_roomnames, :string),
      expire_state: Randoms.random(:expire_state, :integer),
      share_status: Randoms.random(:share_status, :integer),
      group_action_type: Randoms.random(:group_action_type, :integer),
      cache_has_attachments: Randoms.random(:cache_has_attachments, :integer),
      is_read: Randoms.random(:is_read, :boolean_int),
      other_handle: Randoms.random(:other_handle, :integer),
      is_emote: Randoms.random(:is_emote, :boolean_int),
      attributedbody: Randoms.random(:attributedbody, :binary),
      message_action_type: Randoms.random(:message_action_type, :integer),
      is_forward: Randoms.random(:is_forward, :boolean_int),
      is_finished: Randoms.random(:is_finished, :boolean_int),
      date: Randoms.random(:integer),
      is_empty: Randoms.random(:is_empty, :boolean_int),
      is_prepared: Randoms.random(:is_prepared, :boolean_int),
      text: Randoms.random(:text, :string),
      is_system_message: Randoms.random(:is_system_message, :boolean_int),
      version: Randoms.random(:version, :integer),
      share_direction: Randoms.random(:share_direction, :integer),
      is_archive: Randoms.random(:is_archive, :boolean_int)
    }
  end

  def fixture(:contact_without_photo) do
    struct = fixture(:contact_with_photo)
    Map.put(struct, :photos, [])
  end

  def fixture(:contact_photo) do
    %{
      params: %{encoding: "BASE64", type: "JPEG"},
      type: "binary",
      value:
        "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"
    }
  end

  def fixture(:jcard_no_photo) do
    [
      "vcard",
      [
        [
          "version",
          %{},
          "text",
          "3.0"
        ],
        [
          "prodid",
          %{},
          "text",
          "-//Apple Inc.//Mac OS X 10.13.6//EN"
        ],
        [
          "n",
          %{},
          "text",
          [
            "Updegrave",
            "Cody",
            "",
            "",
            ""
          ]
        ],
        [
          "fn",
          %{},
          "text",
          " Cody  Updegrave "
        ],
        [
          "tel",
          %{
            type: [
              "HOME",
              "VOICE",
              "pref"
            ]
          },
          "phone-number",
          "(301) 904-5644"
        ]
      ],
      []
    ]
  end

  def fixture(:jcard_with_photo) do
    [
      "vcard",
      [
        [
          "version",
          %{},
          "text",
          "3.0"
        ],
        [
          "prodid",
          %{},
          "text",
          "-//Apple Inc.//Mac OS X 10.13.6//EN"
        ],
        [
          "n",
          %{},
          "text",
          [
            "Stafford",
            "Bethany",
            "",
            "",
            ""
          ]
        ],
        [
          "fn",
          %{},
          "text",
          " Bethany  Stafford "
        ],
        [
          "tel",
          %{
            type: [
              "CELL",
              "VOICE",
              "pref"
            ]
          },
          "phone-number",
          "+16464381825"
        ],
        [
          "x-socialprofile",
          %{
            type: "facebook",
            "x-userid": "9016070",
            "x-displayname": "Bethany Stafford"
          },
          "unknown",
          "http://www.facebook.com/BStaff"
        ],
        [
          "x-socialprofile",
          %{
            type: "twitter",
            "x-userid": "887586083336323073",
            "x-displayname": "PublishedVoiceLLC"
          },
          "unknown",
          "http://twitter.com/llc_voice"
        ],
        [
          "photo",
          %{
            type: "JPEG",
            encoding: "BASE64"
          },
          "binary",
          "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"
        ]
      ],
      []
    ]
  end

  def fixture(:contact_no_photo) do
    %{
      addresses: [],
      cal_uris: [],
      emails: [],
      fullname: %{params: %{}, type: "text", value: " Cody  Updegrave "},
      identifier_name: "Cody  Updegrave",
      identifier_number: "(301) 904-5644",
      identifier_numbers: ["3019045644"],
      impps: [],
      initials: "CU",
      name: %{params: %{}, type: "text", value: ["Updegrave", "Cody", "", "", ""]},
      phone_numbers: [
        %{
          params: %{type: ["HOME", "VOICE", "pref"]},
          type: "phone-number",
          value: "(301) 904-5644"
        }
      ],
      photos: [],
      social_profiles: [],
      urls: [],
      x_abadr: []
    }
  end

  def fixture(:contact_with_photo) do
    %{
      addresses: [],
      cal_uris: [],
      emails: [],
      fullname: %{params: %{}, type: "text", value: " Bethany  Stafford "},
      identifier_name: "Bethany  Stafford",
      identifier_number: "+16464381825",
      identifier_numbers: ["6464381825"],
      impps: [],
      initials: "BS",
      name: %{params: %{}, type: "text", value: ["Stafford", "Bethany", "", "", ""]},
      phone_numbers: [
        %{
          params: %{type: ["CELL", "VOICE", "pref"]},
          type: "phone-number",
          value: "+16464381825"
        }
      ],
      photos: [
        %{
          params: %{encoding: "BASE64", type: "JPEG"},
          type: "binary",
          value:
            "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"
        }
      ],
      social_profiles: [],
      urls: [],
      "x-socialprofile": %{
        params: %{
          type: "twitter",
          "x-displayname": "PublishedVoiceLLC",
          "x-userid": "887586083336323073"
        },
        type: "unknown",
        value: "http://twitter.com/llc_voice"
      },
      x_abadr: []
    }
  end
end
