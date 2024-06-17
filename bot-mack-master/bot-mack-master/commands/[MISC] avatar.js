const { MessageEmbed } = require("discord.js");

module.exports = {
  name: "avatar",
  description: "Show your discord avatar as PM",
  execute(message) {
    message.reply(message.author.displayAvatarURL());
    const discord = require("discord.js");
    const client = new discord.Client();
    const user = client.users.cache.get("id");
    const channel = client.channels.cache.get("id");
    console.log(message.author.username + " used .avatar");
    return message.author.send(message.author.displayAvatarURL());
    
  }
};