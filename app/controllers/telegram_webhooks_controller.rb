class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  before_action :get_telegram_client, :set_locale

  def start!(*)
    respond_with :message, text: t('.content', first_name: from['first_name'])
  end

  def help!(*)
    respond_with :message, text: t('.content')
  end

  def memo!(*args)
    if args.any?
      session[:memo] = args.join(' ')
      respond_with :message, text: t('.notice')
    else
      respond_with :message, text: t('.prompt')
      save_context :memo!
    end
  end

  def remind_me!(*)
    to_remind = session.delete(:memo)
    reply = to_remind || t('.nothing')
    respond_with :message, text: reply
  end

  def keyboard!(value = nil, *)
    puts "**** Recibimos #{value} del teclado"
    case value
    when "Today", "Hoy"
      menus = Menu.where(date: Date.today)
      if menus.any?
        text = t("messages.today_menu_is") + ":\n"
        menus.each do |menu|
          text += menu.menu_type + " -> " + menu.description + "\n"
        end
      else
        text = t("messages.no_menu_for_day", l(Date.today)) + ": "
      end
      respond_with :message, text: text
    when "Tomorrow", "Mañana"
      menus = Menu.where(date: Date.today + 1.day)
      if menus.any?
        text = t("messages.tomorrow_menu_is") + ":\n"
        menus.each do |menu|
          text += menu.menu_type + " -> " + menu.description + "\n"
        end
      else
        text = t("messages.no_menu_for_day", l(Date.today)) + ": "
      end
      respond_with :message, text: text
    else
      save_context :keyboard!
      respond_with :message, text: t('.prompt'), reply_markup: {
        keyboard: [t('.buttons')],
        resize_keyboard: true,
        one_time_keyboard: true,
        selective: true,
      }
    end
  end

  def inline_keyboard!(*)
    respond_with :message, text: t('.prompt'), reply_markup: {
      inline_keyboard: [
        [
          {text: t('.alert'), callback_data: 'alert'},
          {text: t('.no_alert'), callback_data: 'no_alert'},
        ],
        [{text: t('.repo'), url: 'https://github.com/sramos/elolivar-bot'}],
      ],
    }
  end

  def callback_query(data)
    if data == 'alert'
      answer_callback_query t('.alert'), show_alert: true
    else
      answer_callback_query t('.no_alert')
    end
  end

  def message(message)
    respond_with :message, text: t('.content', text: message['text'])
  end

  def inline_query(query, _offset)
    query = query.first(10) # it's just an example, don't use large queries.
    t_description = t('.description')
    t_content = t('.content')
    results = Array.new(5) do |i|
      {
        type: :article,
        title: "#{query}-#{i}",
        id: "#{query}-#{i}",
        description: "#{t_description} #{i}",
        input_message_content: {
          message_text: "#{t_content} #{i}",
        },
      }
    end
    answer_inline_query results
  end

  # As there is no chat id in such requests, we can not respond instantly.
  # So we just save the result_id, and it's available then with `/last_chosen_inline_result`.
  def chosen_inline_result(result_id, _query)
    session[:last_chosen_inline_result] = result_id
  end

  def last_chosen_inline_result!(*)
    result_id = session[:last_chosen_inline_result]
    if result_id
      respond_with :message, text: t('.selected', result_id: result_id)
    else
      respond_with :message, text: t('.prompt')
    end
  end

  def action_missing(action, *_args)
    if action_type == :command
      respond_with :message,
        text: t('telegram_webhooks.action_missing.command', command: action_options[:command])
    else
      respond_with :message, text: t('telegram_webhooks.action_missing.feature', action: action)
    end
  end

  def get_telegram_client
    @telegram_client = Client.find_or_create_by telegram_id: from['id']
    @telegram_client.update_attributes username: from['username'],
                                       first_name: from['first_name'],
                                       is_bot: from['is_bot'],
                                       updated_at: Time.now
  end

  def set_locale
    I18n.locale = from['language_code'] || I18n.default_locale
  end
end
