import rss from '@astrojs/rss';

import { getCollection } from "astro:content";

const allPosts = await getCollection("blog");
const sortedPosts = Object.values(allPosts).sort(
	(a, b) => new Date(b.data.date).valueOf() - new Date(a.data.date).valueOf(),
);

export async function GET(context) {
  return rss({
    title: 'Astro Learner | Blog',
    description: 'My journey learning Astro',
    site: context.site,
    items: sortedPosts.map((item) => ({
		title: item.data.title,
		description: item.data.description,
		link: `blog/${item.slug}`,
		pubDate: new Date(item.data.date),
	})),
    customData: `<language>en-us</language>`,
  })
}