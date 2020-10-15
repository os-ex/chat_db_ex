defmodule ChatDbEx.SQLiteQueries do
  @moduledoc """
  iMessage chatdb queries.
  """

  # defp get_current_max_rowid() do
  #   # Check to see if we have one stored.
  #   case DB.get!(:state, "imsg_max_rowid") do
  #     nil ->
  #       # Haven't seen it before, use the max of ROWID.
  #       [[ROWID: rowid]] = query("SELECT MAX(message.ROWID) AS ROWID FROM message;")
  #       DB.set(:state, "imsg_max_rowid", rowid)
  #       rowid

  #     res ->
  #       res
  #   end
  # end

  def unix_datetime(name, as: as) do
    """
    datetime(
      #{name} / 1000000000 + strftime("%s", "2001-01-01"),
      "unixepoch",
      "localtime"
    ) AS #{as}
    """
  end

  def boolean_int(name, as: as) do
    "#{name} AS #{as}"
  end

  def sql(query, opts \\ %{})

  def sql(:max_chat_id, _) do
    """
    SELECT
      MAX(chat.ROWID) AS max_chat_id
    FROM
      chat
    """
  end

  def sql(:max_message_id, _) do
    """
    SELECT
      MAX(message.ROWID) AS max_message_id
    FROM
      message
    """
  end

  def sql(:last_message_at, %{rowid: rowid}) do
    # {unix_datetime("message.date", as: "utc_date")}
    """
    SELECT
      datetime(message.date/1000000000 + strftime("%s", "2001-01-01"), "unixepoch", "localtime") AS utc_datetime
    FROM
      message
      JOIN
        chat_message_join
        ON chat_message_join.message_id = message.ROWID
    WHERE
      chat_message_join.chat_id = #{rowid}
    ORDER BY
      date DESC
    LIMIT 1
    """
  end

  def sql(:last_message_text, %{rowid: rowid}) do
    """
    SELECT
      text
    FROM
      message
      JOIN
        chat_message_join
        ON chat_message_join.message_id = message.ROWID
    WHERE
      chat_message_join.chat_id = #{rowid}
    ORDER BY
      date DESC
    LIMIT 1
    """
  end

  def sql(:last_message, %{rowid: chat_id}) do
    """
    SELECT
      handle.ROWID AS handle_id,
      handle.id AS handle_identifier,
      handle.uncanonicalized_id AS handle_uncanonicalized_id,
      message.ROWID AS id,
      message.guid AS guid,
      message.text AS text,
      message.subject AS subject,
      message.cache_roomnames AS cache_roomnames,
      cast(message.is_read AS boolean) AS is_read,
      message.is_sent AS is_sent,
      message.is_from_me AS is_from_me,
      message.cache_has_attachments AS has_attachments,
      datetime(message.date/1000000000 + strftime("%s", "2001-01-01"), "unixepoch", "localtime") AS utc_datetime,
      datetime(message.date_read/1000000000 + strftime("%s", "2001-01-01"), "unixepoch", "localtime") AS utc_datetime_read,
      datetime(message.date_played/1000000000 + strftime("%s", "2001-01-01"), "unixepoch", "localtime") AS utc_datetime_played,
      datetime(message.date_delivered/1000000000 + strftime("%s", "2001-01-01"), "unixepoch", "localtime") AS utc_datetime_delivered
    FROM
      message
      JOIN
        chat_message_join
        ON chat_message_join.message_id = message.ROWID
    WHERE
      chat_message_join.chat_id = #{chat_id}
    ORDER BY
      date DESC
       LIMIT 1
    """
  end

  def sql(:last_message, _opts) do
    """
    SELECT
      handle.ROWID AS handle_id,
      handle.id AS handle_identifier,
      handle.uncanonicalized_id AS handle_uncanonicalized_id,
      message.ROWID AS id,
      message.guid AS guid,
      message.text AS text,
      message.subject AS subject,
      message.cache_roomnames AS cache_roomnames,
      cast(message.is_read AS boolean) AS is_read,
      message.is_sent AS is_sent,
      message.is_from_me AS is_from_me,
      message.cache_has_attachments AS has_attachments,
      datetime(message.date/1000000000 + strftime("%s", "2001-01-01"), "unixepoch", "localtime") AS utc_datetime,
      datetime(message.date_read/1000000000 + strftime("%s", "2001-01-01"), "unixepoch", "localtime") AS utc_datetime_read,
      datetime(message.date_played/1000000000 + strftime("%s", "2001-01-01"), "unixepoch", "localtime") AS utc_datetime_played,
      datetime(message.date_delivered/1000000000 + strftime("%s", "2001-01-01"), "unixepoch", "localtime") AS utc_datetime_delivered
    FROM
      message
      INNER JOIN
        handle
        ON message.handle_id = handle.ROWID
    ORDER BY
      date DESC
    LIMIT 1
    """
  end

  def sql(:chat_messages_count, %{rowid: rowid}) do
    """
    SELECT
      count(message.ROWID) AS count
    FROM
      message
      JOIN
        chat_message_join
        ON chat_message_join.message_id = message.ROWID
    WHERE
      chat_message_join.chat_id = #{rowid}
    """
  end

  def sql(:chats_since, %{rowid: rowid}) do
    # {unix_datetime("message.date", as: "utc_date")}
    """
    SELECT
      chat.ROWID AS id,
      (
        SELECT
          datetime(message.date/1000000000 + strftime("%s", "2001-01-01"), "unixepoch", "localtime")
        FROM
          message
          JOIN
            chat_message_join
            ON chat_message_join.message_id = message.ROWID
        WHERE
          chat_message_join.chat_id = chat.ROWID
        ORDER BY
          date DESC LIMIT 1
      )
      AS last_message_at,
      (
        SELECT
          text
        FROM
          message
          JOIN
            chat_message_join
            ON chat_message_join.message_id = message.ROWID
        WHERE
          chat_message_join.chat_id = chat.ROWID
        ORDER BY
          date DESC LIMIT 1
      )
      AS last_message_text,
      (
        SELECT
          count(DISTINCT message.ROWID)
        FROM
          message
          JOIN
            chat_message_join
            ON chat_message_join.message_id = message.ROWID
        WHERE
          chat_message_join.chat_id = chat.ROWID
      )
      AS messages_count
      FROM
        chat
      WHERE
        chat.ROWID > #{rowid}
      ORDER BY
        last_message_at DESC
    """
  end

  def sql(:messages_since, %{rowid: rowid}) do
    """
    SELECT
      handle.ROWID AS handle_id,
      handle.id AS handle_identifier,
      handle.uncanonicalized_id AS handle_uncanonicalized_id,
      message.ROWID AS id,
      message.guid AS guid,
      message.text AS text,
      message.subject AS subject,
      message.cache_roomnames AS cache_roomnames,
      cast(message.is_read AS boolean) AS is_read,
      message.is_sent AS is_sent,
      message.is_from_me AS is_from_me,
      message.cache_has_attachments AS has_attachments,
      datetime(message.date/1000000000 + strftime("%s", "2001-01-01"), "unixepoch", "localtime") AS utc_datetime,
      datetime(message.date_read/1000000000 + strftime("%s", "2001-01-01"), "unixepoch", "localtime") AS utc_datetime_read,
      datetime(message.date_played/1000000000 + strftime("%s", "2001-01-01"), "unixepoch", "localtime") AS utc_datetime_played,
      datetime(message.date_delivered/1000000000 + strftime("%s", "2001-01-01"), "unixepoch", "localtime") AS utc_datetime_delivered
    FROM
      message
      INNER JOIN
        handle
        ON message.handle_id = handle.ROWID
    WHERE
      message.ROWID > #{rowid}
    """

    # """
    # SELECT handle.id,
    # handle.uncanonicalized_id,
    # message.cache_has_attachments,
    # message.text,
    # message.ROWID,
    # message.cache_roomnames,
    # message.is_from_me,
    # message.date/1000000000 + strftime("%s", "2001-01-01") AS utc_date
    #  FROM message INNER JOIN handle ON message.handle_id = handle.ROWID WHERE message.ROWID > #{
    #   rowid
    # };
    # """
  end

  def sql(:attachments_since, %{rowid: rowid}) do
    """
    SELECT
      attachment.ROWID AS attachment_id,
      message_attachment_join.message_id AS message_id,
      attachment.filename,
      attachment.mime_type,
      attachment.total_bytes
    FROM
      attachment
      INNER JOIN
        message_attachment_join
        ON attachment.ROWID == message_attachment_join.attachment_id
    WHERE
      message_attachment_join.message_id >= #{rowid}
    """
  end

  def query(:list_messages) do
    ~s(
      SELECT * from message ORDER BY ROWID DESC LIMIT 1
    )
  end

  def query(:list_messages_with_assocs) do
    ~s{
      SELECT
        message.ROWID,
        text,
        is_from_me,
        handle.id AS handle_identifier,
        cache_has_attachments,
        datetime(
          message.date / 1000000000 + strftime("%s", "2001-01-01"),
          "unixepoch", "localtime"
        ) AS sent_at
    }
    # .includes(:attachments, chats: :handles)
    # .joins("LEFT JOIN handle on handle.ROWID = message.handle_id")
  end

  def query(:list_chats_with_assocs) do
    ~s{
      SELECT
        chat.ROWID,
        (
          SELECT datetime(
            message.date / 1000000000 + strftime("%s", "2001-01-01"),
            "unixepoch", "localtime"
          ) AS date_utc
          FROM message
          JOIN chat_message_join ON chat_message_join.message_id = message.ROWID
          WHERE chat_message_join.chat_id = chat.ROWID
          ORDER BY date DESC
          LIMIT 1
        ) AS last_msg_at,
        (
          SELECT text
          FROM message
          JOIN chat_message_join ON chat_message_join.message_id = message.ROWID
          WHERE chat_message_join.chat_id = chat.ROWID
          ORDER BY date DESC
          LIMIT 1
        ) AS last_text
    }
    # .includes(:handles)
  end

  # @path 'db/Messages/chat.db'

  # def import do
  #   # Sqlitex.with_db(@path, fn db ->
  #   #   Sqlitex.query(
  #   #     db,
  #   #     "INSERT INTO players (name, created_at, updated_at) VALUES (?1, ?2, ?3, ?4)",
  #   #     bind: ['Mikey', '2012-10-14 05:46:28.318107', '2013-09-06 22:29:36.610911']
  #   #   )
  #   # end)

  #   :list_messages
  #   |> query()
  #   |> with_connection()
  # end
end
