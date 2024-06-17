import { component } from "@astrojs/markdoc/config";

// /** @type {import('@markdoc/markdoc').Schema} */
export const callout = {
	render: component("./src/utils/mdoc/components/Callout.astro"),
	children: ["paragraph", "tag", "list"],
	attributes: {
		type: {
			type: String,
			default: "note",
			matches: ["error", "check", "note", "warning"],
			errorLevel: "critical",
		},
		title: {
			type: String,
		},
	},
};
