const { MessageEmbed } = require("discord.js");

module.exports = {
  name: "say",
  description: "bot says",
  execute(message, args) {
    let argsresult;
    let mChannel = message.mentions.channels.first()

    message.delete({ timeout: 0, reason: 'STAY ANONYMOUS' });
    if(mChannel) {
        argsresult = args.slice(1).join(" ")
        message.channel.send(argsresult)
    } else {
        argsresult = args.join(" ")
        message.channel.send(argsresult)
    }
    console.log(message.author);
    console.log(message.author.username + " used the .say to say > " + argsresult);
  }
}
