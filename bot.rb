require 'telegram_bot'
require 'httparty'
require "json"

token = ENV["BOT_TOKEN"]

bot = TelegramBot.new(token: token)

bot.get_updates(fail_silently: true) do |message|
    puts "@#{message.from.username}: #{message.text}"
    command = message.get_command_for(bot)
    tips = []
    tips.push("No importa el precio, siempre es buen momento de comprar Bitcoin")
    tips.push("Los bancos centrales tienen miedo")
    tips.push("Odio Bitcoin Cash")
    tips.push("10,000 nuevos seguidores y regalo un LTC")
    tips.push("El Bitcoin como reserva de valor")
    tips.push("Me gustan los tacos de pastor veganos")
    tips.push("BitVenue nunca te pedirá dinero")
    tips.push("Bitcoin to the moon")

    message.reply do |reply|
        if command != nil && command.match(/^\/[a-z0-9]/i)
            case command
            when /ayuda/i
                reply.text = "Escribe:\n" \
                    "/tip       para recibir uno de mis sabios consejos.\n" \
                    "/precio    BTCUSDT para saber el precio del bitcoin (funciona con otras monedas).\n" \
                    "/canal     para obtener la liga a nuestro canal de Youtube.\n" \
                    "/libros    para ver nuestra colección de audio libros.\n" \
                    "/curso     para visitar nuestro curso online gratuito.\n" \
                    "/version   para saber que versión soy"
            when /tip/i
                reply.text = tips.sample.capitalize
            when /canal/i
                reply.text = "Visita nuestro canal de Youtube en https://www.youtube.com/channel/UC2bDe-M0oGqSd87RZiQCuoQ"
            when /libros/i
                reply.text = "Checa nuestra colección de audiolibros en https://cutt.ly/VfLRutg"
            when /curso/i
                reply.text = "Toma nuestro curso en linea GRATIS https://campus.elartedeinvertirenbolsa.com"
            when /precio/i
                if command.inspect.split.length == 2
                    market = command.inspect.split.at(1).delete_suffix('"')
                    response = HTTParty.get("https://api.binance.com/api/v3/avgPrice?symbol=#{market}")
                    puts "/api/v3/avgPrice?symbol=#{market}"
                    puts market
                    puts response.body
                    if response.code == 200
                        result = JSON.parse(response.body)
                        reply.text = "#{market} está en #{result["price"]}"
                    else
                        reply.text = "Ahorita no sé el precio de #{market}, pero el BTC está como a 50k USDT."
                    end
                else
                    reply.text = "Dame un mercado, intenta /precio BTCUSDT"
                end
            when /version/i
                reply.text = "Version 1.0.2"
            else
                reply.text = "Aun no entiendo #{command.inspect}. Intenta /ayuda"
            end
            puts "sending #{reply.text.inspect} to @#{message.from.username}"
            reply.send_with(bot)
        end
    end
  end
