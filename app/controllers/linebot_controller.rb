class LinebotController < ApplicationController
  require 'line/bot'

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.credentials.line_secret_key
      config.channel_token = Rails.application.credentials.line_access_token
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    head :bad_request unless client.validate_signature(body, signature)

    events = client.parse_events_from(body)

    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          # LINEから送られてきたメッセージが「アンケート」と一致するかチェック
          if event.message['text'].eql?('アンケート')
            # private内のtemplateメソッドを呼び出します。
            client.reply_message(event['replyToken'], template)
          end
        end
      end
    }

    head :ok
  end

  private

  def template
    {
      "type": "template",
      "altText": "this is a confirm template",
      "template": {
        "type": "confirm",
        "text": "今日のもくもく会は楽しいですか？",
        "actions": [
          {
            "type": "message",
            # Botから送られてきたメッセージに表示される文字列です。
            "label": "楽しい",
            # ボタンを押した時にBotに送られる文字列です。
            "text": "楽しい"
          },
          {
            "type": "message",
            "label": "楽しくない",
            "text": "楽しくない"
          }
        ]
      }
    }
  end
end
