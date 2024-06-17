import { component } from "@astrojs/markdoc/config";

/** @type {import('@markdoc/markdoc').Schema} */
export const tweetEmbed = {
	render: component("./src/utils/mdoc/components/TweetEmbed.astro"),
	attributes: {
		url: {
			type: String,
			required: true,
		},
	},
};
