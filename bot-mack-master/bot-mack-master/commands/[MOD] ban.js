const Discord = require('discord.js');
module.exports = {
  name: "ban",
  description: "Ban user",
  execute(message) {
    

if (message.guild.member(message.author).hasPermission('BAN_MEMBERS'))
{
  if (message.mentions.users.size === 0) { return message.channel.send('You need to ping a user!'); }
let kickMemver = message.guild.member(message.mentions.users.first());
if (!kickMemver) { return message.channel.send('User not found!'); }

     kickMemver.ban().then((member) => {
          message.channel.send(member.displayName + " has been successfully banned by a moderator");
      })
}
else
  message.channel.send('[ERROR] NO PERMISSION');
  console.log(message.author.username + " banned " + member.displayName);  
}
}