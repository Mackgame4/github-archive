const { MessageEmbed } = require("discord.js");

module.exports = {
  name: "help",
  description: "Display all commands and descriptions",
  execute(message) {
    const discord = require("discord.js");
    const client = new discord.Client();
    const user = client.users.cache.get("id");
    const channel = client.channels.cache.get("id");

    let commands = message.client.commands.array();

    let helpEmbed = new MessageEmbed()
      .setColor("#9b34eb")
      .setTitle("Help Me")
      .setAuthor("Indigo eSports")
      .setDescription("List of all commands")
      .setThumbnail(
        "https://cdn.discordapp.com/avatars/315802629382995968/339faacbc82e7bffc3b511a11d73559c.webp"
      )
      .setTimestamp()
      .setFooter(
        "By: Mack",
        "https://cdn.discordapp.com/avatars/263676903116898304/a080fe4afe6f9a8a122f77e9f273b9e0.webp"
      );

    commands.forEach(cmd => {
      helpEmbed.addField(
        `${message.client.prefix}${cmd.name}`,
        `${cmd.description}`
      );
    });

    helpEmbed.setTimestamp();

    return message.author.send(helpEmbed);
  }
};