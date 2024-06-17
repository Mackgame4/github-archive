export type NavItems = {
	[key: string]: NavItem;
};

export type NavItem = {
	path: string;
	title: string;
};

export const NAV_ITEMS: NavItems = {
	home: {
		path: "/",
		title: "Inicio",
	},
	blog: {
		path: "/blog",
		title: "Blog",
	},
	tags: {
		path: "/tags",
		title: "Tags",
	},
	docs: {
		path: "/docs",
		title: "Documentos",
	},
	about: {
		path: "/about",
		title: "Sobre Nós",
	},
};

export const SITE = {
	// Your site's details
	name: "CECRI",
	title: "CECRI.UMINHO",
	description: "O Centro de Estudos do Curso de Relações Internacionais é uma associação estudantil composta por alunos de Relações Internacionais da Universidade do Minho.",
	url: "https://astro-ink.vercel.app",
	githubUrl: "https://github.com/one-aalam/astro-ink",
	bannerImage: "https://media.licdn.com/dms/image/C4E0BAQG0_4rDWa-lug/company-logo_200_200/0/1633008309313/cecri_uminho_logo?e=2147483647&v=beta&t=ZutpIfRcTO6pCHuh8E_wPgn2wUEvQejnVG7J92Tv1lI",
	defaultPostAuthor: "CECRI",
	defaultAuthorImage: "https://media.licdn.com/dms/image/C4E0BAQG0_4rDWa-lug/company-logo_200_200/0/1633008309313/cecri_uminho_logo?e=2147483647&v=beta&t=ZutpIfRcTO6pCHuh8E_wPgn2wUEvQejnVG7J92Tv1lI",
	dateLocaleFormat: "pt-PT"
};

export const PAGE_SIZE = 8; // whats this?

// Locales
export const MONTHS = [
	"Jan",
	"Fev",
	"Mar",
	"Abr",
	"Mai",
	"Jun",
	"Jul",
	"Ago",
	"Set",
	"Out",
	"Nov",
	"Dez",
];