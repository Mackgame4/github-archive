const Discord = require('discord.js');
const client = new Discord.Client();
module.exports = {
  name: "kick",
  description: "Kick user",
  execute(message) {
    

if (message.guild.member(message.author).hasPermission('KICK_MEMBERS'))
{
  if (message.mentions.users.size === 0) { return message.channel.send('You need to ping a user!'); }
let kickMemver = message.guild.member(message.mentions.users.first());
if (!kickMemver) { return message.channel.send('User not found!'); }

     kickMemver.kick().then((member) => {
          message.channel.send(member.displayName + " has been successfully kick by a moderator");
      })
}
else
  message.channel.send('[ERROR] NO PERMISSION');
  }
}