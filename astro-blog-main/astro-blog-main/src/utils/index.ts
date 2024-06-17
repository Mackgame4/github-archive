import path from "path";
import { MONTHS } from "../config";

export const toTitleCase = (str: string) =>
	str.replace(/\w\S*/g, function (txt) {
		return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
	});

export const getMonthName = (date: Date) => MONTHS[new Date(date).getMonth()];

export const getSlugFromPathname = (pathname: string) =>
	path.basename(pathname, path.extname(pathname));
