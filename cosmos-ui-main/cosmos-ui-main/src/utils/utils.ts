import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export const debugMode = true

// retusn the "theme" prop from c-provider
export function getTheme() {
  const root = document.querySelector("c-provider") as HTMLElement;
  const theme = root.getAttribute("theme") || "default";
  if (theme === "default") {
    return "shadcn" // default theme
  }
  return theme;
}

// cn(normal class, possible variants, choosen variants)
export function cn(
  className: ClassValue,
  variants?: Record<string, Record<string, ClassValue>>,
  choosenVariants?: Record<string, string>
) {
  if (variants && choosenVariants) {
    const variantClasses = Object.entries(choosenVariants).map(([key, value]) => variants[key][value])
    return twMerge(clsx(className, ...variantClasses, "customElement"))
  } else {
    return twMerge(clsx(className, "customElement"))
  }
}

export function toggleDark(darkMode: boolean) {
  const root = document.querySelector("c-provider") as HTMLElement;
  const processElements = (elements: NodeListOf<HTMLElement>) => {
    elements.forEach(element => {
      element.classList.toggle("dark", darkMode);
      if (element.shadowRoot) {
        const shadowElements = element.shadowRoot.querySelectorAll(".customElement") as NodeListOf<HTMLElement>;
        processElements(shadowElements);
      }
    });
  };
  const allElements = root.querySelectorAll("*") as NodeListOf<HTMLElement>;
  processElements(allElements);
}

// funtion "getComponents"
import docs from "./docs.json";
export function getComponents() {
  return docs.components
}