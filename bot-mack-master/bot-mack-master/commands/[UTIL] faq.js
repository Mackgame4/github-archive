module.exports = {
  name: "faq",
  description: "FAQ",
  execute(message) {
    return message.channel.send(
      "Why is the bot english?\n - Cuz I want to \n Is the bot open source?\n - Yes, As soon as I finish developing the bot, it will be available on github"
    );
  }
};