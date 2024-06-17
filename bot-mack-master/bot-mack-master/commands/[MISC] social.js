const { MessageEmbed } = require("discord.js");

module.exports = {
  name: "social",
  description: "Display all my social media",
  execute(message) {
    let helpEmbed = new MessageEmbed()
      .setColor("#9b34eb")
      .setTitle("Social Media")
      .setAuthor("Mack")
      .setDescription("List of all my social media")
      .setThumbnail(
        "https://cdn.discordapp.com/avatars/263676903116898304/a080fe4afe6f9a8a122f77e9f273b9e0.webp"
      )
      .addFields(
        { name: "Twitch", value: "https://www.twitch.tv/mackgame4" },
        { name: "GitHub", value: "https://github.com/mackgame4" }
      )
      .setTimestamp()
      .setFooter(
        "By: Mack",
        "https://cdn.discordapp.com/avatars/263676903116898304/a080fe4afe6f9a8a122f77e9f273b9e0.webp"
      );

    helpEmbed.setTimestamp();

    return message.channel.send(helpEmbed);
  }
};