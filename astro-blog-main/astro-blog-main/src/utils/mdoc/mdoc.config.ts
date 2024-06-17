import { badge } from "./schema/badge.mdoc";
import { callout } from "./schema/callout.mdoc";
import { link } from "./schema/link.mdoc";
import { tweetEmbed } from "./schema/tweet-embed.mdoc";
import { tabs } from "./schema/tabs.mdoc";
import { ytEmbed } from "./schema/yt-embed.mdoc";

/** @type {import('@markdoc/markdoc').Config} */
export const config = {
	tags: {
		badge,
		callout,
		link,
		tweet: tweetEmbed,
		yt: ytEmbed,
		tabs,
	},
	functions: {
		getCountryEmoji: {
			transform(parameters: any) {
				const [country] = Object.values(parameters);
				const countryToEmojiMap = {
					japan: "🇯🇵",
					portugal: "🇵🇹",
					spain: "🇪🇸",
					france: "🇫🇷",
					italy: "🇮🇹",
					germany: "🇩🇪",
					uk: "🇬🇧",
					usa: "🇺🇸",
					canada: "🇨🇦",
					australia: "🇦🇺",
					india: "🇮🇳",
					brazil: "🇧🇷",
					russia: "🇷🇺",
					china: "🇨🇳",
					"united arab emirates": "🇦🇪",
					"new zealand": "🇳🇿",
					switzerland: "🇨🇭",
					netherlands: "🇳🇱",
				};
				return countryToEmojiMap[country as string] ?? "🏳";
			},
		},
	},
};
