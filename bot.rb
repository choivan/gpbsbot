require 'telegram_bot'
require 'pp'
require 'logger'

logger = Logger.new(STDOUT, Logger::DEBUG)

bot = TelegramBot.new(token: '240058626:AAEdQOZlM89DhlmS_FsIXSMPEANwEjqJICg', logger: logger)
logger.debug "starting telegram bot"

duel_starter = nil

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

    when /doved/i
      doved = rand(2) > 0
      name = command.sub('/doved', '').strip
      name = message.from.first_name if name.empty?
      if doved 
        reply.text = "Yes! #{name}! You ARE D-O-V-E-D!"
      else 
        reply.text = "You got luck, #{name} :-p"
      end 

    when /duel/i
      msg = command.sub('/duel', '').strip
      if duel_starter == nil 
        msg = "WHO DARE TO FIGHT WITH ME?!" if msg.empty?
        duel_starter = message.from.first_name
        reply.text = "#{duel_starter} roooaaarrrs, \"#{msg}\""
      else 
        participant = message.from.first_name
        if duel_starter == participant
          reply.text = "Hey, #{duel_starter}. You cannot duel with yourself."
        else 
          winner = rand(2) > 0? duel_starter : participant
          reply_text_heading = msg.empty?? "" : "\"#{msg}\", #{participant} yells.\n"
          reply.text = reply_text_heading + "#{participant} enters the duel with #{duel_starter}\n...\n...\nAnd the winner is #{winner}"
          duel_starter = nil
        end
      end 

    else
      reply.text = "#{message.from.first_name}, have no idea what #{command.inspect} means."
    end
    logger.info "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end

