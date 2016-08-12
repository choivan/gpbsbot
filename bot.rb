require 'telegram_bot'
require 'pp'
require 'logger'

logger = Logger.new(STDOUT, Logger::DEBUG)

bot = TelegramBot.new(token: '240058626:AAEdQOZlM89DhlmS_FsIXSMPEANwEjqJICg', logger: logger)
logger.debug "starting telegram bot"

bot.get_updates(fail_silently: false) do |message|
  logger.info "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

  message.reply do |reply|
    case command
    when /roll/i
      def to_i_safe(str, default)
        ret = str.to_i 
        ret = default if ret == 0
        ret
      end
      range = to_i_safe(command.sub('/roll', '').strip, 100)
      logger.info "range is #{range}"
      reply.text = "#{message.from.first_name}, you got #{rand(range)}"

    when /dove/i
      doved = rand(2) > 0
      if doved 
        reply.text = "Yes! #{message.from.first_name}! You ARE D-O-V-E-D!"
      else 
        reply.text = "You got luck, #{message.from.first_name} :-p"
      end 
      
    else
      reply.text = "#{message.from.first_name}, have no idea what #{command.inspect} means."
    end
    logger.info "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end

