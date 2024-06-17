import { proxyCustomElement, HTMLElement, h } from '@stencil/core/internal/client';
import { d as defineCustomElement$2 } from './ux-button2.js';
import { d as defineCustomElement$1 } from './ux-icon2.js';

const timestamp = "2023-01-30T21:02:07";
const compiler = {
	name: "@stencil/core",
	version: "2.22.2",
	typescriptVersion: "4.9.4"
};
const components = [
	{
		filePath: "./src/components/ux-badge/ux-badge.tsx",
		encapsulation: "shadow",
		tag: "ux-badge",
		readme: "# ux-badge\r\n\r\n\r\n\r",
		docs: "",
		docsTags: [
		],
		usage: {
		},
		props: [
			{
				name: "appendIcon",
				type: "string",
				mutable: false,
				attr: "append-icon",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "color",
				type: "string",
				mutable: false,
				attr: "color",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "prependIcon",
				type: "string",
				mutable: false,
				attr: "prepend-icon",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "rounded",
				type: "boolean",
				mutable: false,
				attr: "rounded",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "false",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "size",
				type: "string",
				mutable: false,
				attr: "size",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "'md'",
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "text",
				type: "string",
				mutable: false,
				attr: "text",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "type",
				type: "string",
				mutable: false,
				attr: "type",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			}
		],
		methods: [
		],
		events: [
		],
		listeners: [
		],
		styles: [
		],
		slots: [
		],
		parts: [
		],
		dependents: [
		],
		dependencies: [
			"ux-icon"
		],
		dependencyGraph: {
			"ux-badge": [
				"ux-icon"
			]
		}
	},
	{
		filePath: "./src/components/ux-button/ux-button.tsx",
		encapsulation: "none",
		tag: "ux-button",
		readme: "# ux-button\r\n\r\n\r\n\r",
		docs: "",
		docsTags: [
		],
		usage: {
		},
		props: [
			{
				name: "appendIcon",
				type: "string",
				mutable: false,
				attr: "append-icon",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "block",
				type: "boolean",
				mutable: false,
				attr: "block",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "false",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "color",
				type: "string",
				mutable: false,
				attr: "color",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "disabled",
				type: "boolean",
				mutable: false,
				attr: "disabled",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "false",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "elevation",
				type: "number",
				mutable: false,
				attr: "elevation",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "0",
				values: [
					{
						type: "number"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "loading",
				type: "boolean",
				mutable: false,
				attr: "loading",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "false",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "prependIcon",
				type: "string",
				mutable: false,
				attr: "prepend-icon",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "ring",
				type: "boolean",
				mutable: false,
				attr: "ring",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "false",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "rounded",
				type: "boolean",
				mutable: false,
				attr: "rounded",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "false",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "shadow",
				type: "boolean",
				mutable: false,
				attr: "shadow",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "true",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "size",
				type: "string",
				mutable: false,
				attr: "size",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "'md'",
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "text",
				type: "string",
				mutable: false,
				attr: "text",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "type",
				type: "string",
				mutable: false,
				attr: "type",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "'secondary'",
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			}
		],
		methods: [
		],
		events: [
		],
		listeners: [
		],
		styles: [
		],
		slots: [
		],
		parts: [
		],
		dependents: [
			"ux-playground",
			"ux-provider",
			"ux-video"
		],
		dependencies: [
			"ux-icon"
		],
		dependencyGraph: {
			"ux-button": [
				"ux-icon"
			],
			"ux-playground": [
				"ux-button"
			],
			"ux-provider": [
				"ux-button"
			],
			"ux-video": [
				"ux-button"
			]
		}
	},
	{
		filePath: "./src/components/ux-card/ux-card.tsx",
		encapsulation: "shadow",
		tag: "ux-card",
		readme: "# ux-card\r\n\r\n\r\n\r",
		docs: "",
		docsTags: [
		],
		usage: {
		},
		props: [
		],
		methods: [
		],
		events: [
		],
		listeners: [
		],
		styles: [
		],
		slots: [
		],
		parts: [
		],
		dependents: [
		],
		dependencies: [
		],
		dependencyGraph: {
		}
	},
	{
		filePath: "./src/components/ux-icon/ux-icon.tsx",
		encapsulation: "none",
		tag: "ux-icon",
		readme: "# ux-icon\r\n\r\n\r\n\r",
		docs: "",
		docsTags: [
		],
		usage: {
		},
		props: [
			{
				name: "icon",
				type: "string",
				mutable: false,
				attr: "icon",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "'account-box'",
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "size",
				type: "string",
				mutable: false,
				attr: "size",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "'md'",
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			}
		],
		methods: [
		],
		events: [
		],
		listeners: [
		],
		styles: [
		],
		slots: [
		],
		parts: [
		],
		dependents: [
			"ux-badge",
			"ux-button",
			"ux-select",
			"ux-textinput",
			"ux-video"
		],
		dependencies: [
		],
		dependencyGraph: {
			"ux-badge": [
				"ux-icon"
			],
			"ux-button": [
				"ux-icon"
			],
			"ux-select": [
				"ux-icon"
			],
			"ux-textinput": [
				"ux-icon"
			],
			"ux-video": [
				"ux-icon"
			]
		}
	},
	{
		filePath: "./src/components/ux-otp/ux-otp.tsx",
		encapsulation: "shadow",
		tag: "ux-otp",
		readme: "# ux-otp\n\n\n",
		docs: "",
		docsTags: [
		],
		usage: {
		},
		props: [
			{
				name: "cellLength",
				type: "number",
				mutable: false,
				attr: "cell-length",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "1",
				values: [
					{
						type: "number"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "length",
				type: "number",
				mutable: false,
				attr: "length",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "4",
				values: [
					{
						type: "number"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "separator",
				type: "string",
				mutable: false,
				attr: "separator",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "uppercaseCells",
				type: "boolean",
				mutable: false,
				attr: "uppercase-cells",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "true",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "useSeparators",
				type: "boolean",
				mutable: false,
				attr: "use-separators",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "true",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "value",
				type: "string[]",
				mutable: true,
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				values: [
					{
						type: "string[]"
					}
				],
				optional: false,
				required: false
			}
		],
		methods: [
		],
		events: [
			{
				event: "componentFilled",
				detail: "any",
				bubbles: true,
				cancelable: true,
				composed: true,
				docs: "",
				docsTags: [
				]
			}
		],
		listeners: [
		],
		styles: [
		],
		slots: [
		],
		parts: [
		],
		dependents: [
		],
		dependencies: [
			"ux-textinput"
		],
		dependencyGraph: {
			"ux-otp": [
				"ux-textinput"
			],
			"ux-textinput": [
				"ux-icon"
			]
		}
	},
	{
		filePath: "./src/components/ux-playground/ux-playground.tsx",
		encapsulation: "shadow",
		tag: "ux-playground",
		readme: "# ux-playground\r\n\r\n\r\n\r",
		docs: "",
		docsTags: [
		],
		usage: {
		},
		props: [
		],
		methods: [
		],
		events: [
		],
		listeners: [
		],
		styles: [
		],
		slots: [
		],
		parts: [
		],
		dependents: [
		],
		dependencies: [
			"ux-provider",
			"ux-button",
			"ux-select",
			"ux-textinput"
		],
		dependencyGraph: {
			"ux-playground": [
				"ux-provider",
				"ux-button",
				"ux-select",
				"ux-textinput"
			],
			"ux-provider": [
				"ux-button"
			],
			"ux-button": [
				"ux-icon"
			],
			"ux-select": [
				"ux-icon"
			],
			"ux-textinput": [
				"ux-icon"
			]
		}
	},
	{
		filePath: "./src/components/ux-provider/ux-provider.tsx",
		encapsulation: "none",
		tag: "ux-provider",
		readme: "# ux-provider\r\n\r\n\r\n\r",
		docs: "",
		docsTags: [
		],
		usage: {
		},
		props: [
			{
				name: "customTheme",
				type: "any",
				mutable: false,
				attr: "custom-theme",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "{\r\n    name: 'default',\r\n    colors: {\r\n    }\r\n  }",
				values: [
					{
						type: "any"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "darkTheme",
				type: "boolean",
				mutable: true,
				attr: "dark-theme",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "false",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "debugMode",
				type: "boolean",
				mutable: true,
				attr: "debug-mode",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			}
		],
		methods: [
		],
		events: [
		],
		listeners: [
		],
		styles: [
		],
		slots: [
		],
		parts: [
		],
		dependents: [
			"ux-playground"
		],
		dependencies: [
			"ux-button"
		],
		dependencyGraph: {
			"ux-provider": [
				"ux-button"
			],
			"ux-button": [
				"ux-icon"
			],
			"ux-playground": [
				"ux-provider"
			]
		}
	},
	{
		filePath: "./src/components/ux-select/ux-select.tsx",
		encapsulation: "shadow",
		tag: "ux-select",
		readme: "# ux-select\r\n\r\n\r\n\r",
		docs: "",
		docsTags: [
		],
		usage: {
		},
		props: [
			{
				name: "appendIconOff",
				type: "string",
				mutable: false,
				attr: "append-icon-off",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "'chevron-down'",
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "appendIconOn",
				type: "string",
				mutable: false,
				attr: "append-icon-on",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "'chevron-up'",
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "defaultSelected",
				type: "number",
				mutable: true,
				attr: "default-selected",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "0",
				values: [
					{
						type: "number"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "prependIconOff",
				type: "string",
				mutable: false,
				attr: "prepend-icon-off",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "prependIconOn",
				type: "string",
				mutable: false,
				attr: "prepend-icon-on",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "rotateAppendIcon",
				type: "boolean",
				mutable: false,
				attr: "rotate-append-icon",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "true",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "rotatePrependIcon",
				type: "boolean",
				mutable: false,
				attr: "rotate-prepend-icon",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "false",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "showSelectedOption",
				type: "boolean",
				mutable: true,
				attr: "show-selected-option",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "false",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			}
		],
		methods: [
		],
		events: [
			{
				event: "componentChange",
				detail: "any",
				bubbles: true,
				cancelable: true,
				composed: true,
				docs: "",
				docsTags: [
				]
			}
		],
		listeners: [
		],
		styles: [
		],
		slots: [
		],
		parts: [
		],
		dependents: [
			"ux-playground"
		],
		dependencies: [
			"ux-icon"
		],
		dependencyGraph: {
			"ux-select": [
				"ux-icon"
			],
			"ux-playground": [
				"ux-select"
			]
		}
	},
	{
		filePath: "./src/components/ux-slider/ux-slider.tsx",
		encapsulation: "shadow",
		tag: "ux-slider",
		readme: "# ux-slider\n\n\n",
		docs: "",
		docsTags: [
		],
		usage: {
		},
		props: [
			{
				name: "max",
				type: "number",
				mutable: false,
				attr: "max",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "100",
				values: [
					{
						type: "number"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "min",
				type: "number",
				mutable: false,
				attr: "min",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "0",
				values: [
					{
						type: "number"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "value",
				type: "number",
				mutable: false,
				attr: "value",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "0",
				values: [
					{
						type: "number"
					}
				],
				optional: false,
				required: false
			}
		],
		methods: [
		],
		events: [
			{
				event: "componentChange",
				detail: "any",
				bubbles: true,
				cancelable: true,
				composed: true,
				docs: "",
				docsTags: [
				]
			},
			{
				event: "componentInput",
				detail: "any",
				bubbles: true,
				cancelable: true,
				composed: true,
				docs: "",
				docsTags: [
				]
			}
		],
		listeners: [
		],
		styles: [
		],
		slots: [
		],
		parts: [
		],
		dependents: [
		],
		dependencies: [
		],
		dependencyGraph: {
		}
	},
	{
		filePath: "./src/components/ux-textinput/ux-textinput.tsx",
		encapsulation: "shadow",
		tag: "ux-textinput",
		readme: "# ux-textinput\n\n\n",
		docs: "",
		docsTags: [
		],
		usage: {
		},
		props: [
			{
				name: "appendIcon",
				type: "string",
				mutable: false,
				attr: "append-icon",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "maxlength",
				type: "number",
				mutable: false,
				attr: "maxlength",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				values: [
					{
						type: "number"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "placeholder",
				type: "string",
				mutable: false,
				attr: "placeholder",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "''",
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "prependIcon",
				type: "string",
				mutable: false,
				attr: "prepend-icon",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "rounded",
				type: "boolean",
				mutable: false,
				attr: "rounded",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "false",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "value",
				type: "string",
				mutable: false,
				attr: "value",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "''",
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			}
		],
		methods: [
		],
		events: [
			{
				event: "componentChange",
				detail: "any",
				bubbles: true,
				cancelable: true,
				composed: true,
				docs: "",
				docsTags: [
				]
			},
			{
				event: "componentInput",
				detail: "any",
				bubbles: true,
				cancelable: true,
				composed: true,
				docs: "",
				docsTags: [
				]
			}
		],
		listeners: [
		],
		styles: [
		],
		slots: [
		],
		parts: [
		],
		dependents: [
			"ux-otp",
			"ux-playground"
		],
		dependencies: [
			"ux-icon"
		],
		dependencyGraph: {
			"ux-textinput": [
				"ux-icon"
			],
			"ux-otp": [
				"ux-textinput"
			],
			"ux-playground": [
				"ux-textinput"
			]
		}
	},
	{
		filePath: "./src/components/ux-video/ux-video.tsx",
		encapsulation: "shadow",
		tag: "ux-video",
		readme: "# ux-video\n\n\n",
		docs: "",
		docsTags: [
		],
		usage: {
		},
		props: [
			{
				name: "autoplay",
				type: "boolean",
				mutable: false,
				attr: "autoplay",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "false",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "controls",
				type: "boolean",
				mutable: false,
				attr: "controls",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "true",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "fullscreen",
				type: "boolean",
				mutable: true,
				attr: "fullscreen",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "false",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "loop",
				type: "boolean",
				mutable: false,
				attr: "loop",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "false",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "muted",
				type: "boolean",
				mutable: false,
				attr: "muted",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "this.autoplay || false",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "src",
				type: "string",
				mutable: false,
				attr: "src",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "'https://www.youtube.com/watch?v=Tx9zMFodNtA'",
				values: [
					{
						type: "string"
					}
				],
				optional: false,
				required: false
			},
			{
				name: "theater",
				type: "boolean",
				mutable: true,
				attr: "theater",
				reflectToAttr: false,
				docs: "",
				docsTags: [
				],
				"default": "false",
				values: [
					{
						type: "boolean"
					}
				],
				optional: false,
				required: false
			}
		],
		methods: [
		],
		events: [
		],
		listeners: [
		],
		styles: [
		],
		slots: [
		],
		parts: [
		],
		dependents: [
		],
		dependencies: [
			"ux-button",
			"ux-icon"
		],
		dependencyGraph: {
			"ux-video": [
				"ux-button",
				"ux-icon"
			],
			"ux-button": [
				"ux-icon"
			]
		}
	}
];
const data = {
	timestamp: timestamp,
	compiler: compiler,
	components: components
};

const buildVersion = '1.0.0';
const githubPageURL = 'https://github.com/Mackgame4/uxlibrary';
function getDataComponents() {
  try {
    return data;
  }
  catch (error) {
    return null;
  }
}
function redirectToGithub() {
  window.open(githubPageURL, '_blank');
}

const uxProviderCss = ":host{display:block}:root{--slate-50:#f8fafc;--slate-100:#f1f5f9;--slate-200:#e2e8f0;--slate-300:#cbd5e1;--slate-400:#94a3b8;--slate-500:#64748b;--slate-600:#475569;--slate-700:#334155;--slate-800:#1e293b;--slate-900:#0f172a;--gray-50:#f9fafb;--gray-100:#f3f4f6;--gray-200:#e5e7eb;--gray-300:#d1d5db;--gray-400:#9ca3af;--gray-500:#6b7280;--gray-600:#4b5563;--gray-700:#374151;--gray-800:#1f2937;--gray-900:#111827;--zinc-50:#fafafa;--zinc-100:#f4f4f5;--zinc-200:#e4e4e7;--zinc-300:#d4d4d8;--zinc-400:#a1a1aa;--zinc-500:#71717a;--zinc-600:#52525b;--zinc-700:#3f3f46;--zinc-800:#27272a;--zinc-900:#18181b;--neutral-50:#fafafa;--neutral-100:#f5f5f5;--neutral-200:#e5e5e5;--neutral-300:#d4d4d4;--neutral-400:#a3a3a3;--neutral-500:#737373;--neutral-600:#525252;--neutral-700:#404040;--neutral-800:#262626;--neutral-900:#171717;--stone-50:#fafaf9;--stone-100:#f5f5f4;--stone-200:#e7e5e4;--stone-300:#d6d3d1;--stone-400:#a8a29e;--stone-500:#78716c;--stone-600:#57534e;--stone-700:#44403c;--stone-800:#292524;--stone-900:#1c1917;--red-50:#fef2f2;--red-100:#fee2e2;--red-200:#fecaca;--red-300:#fca5a5;--red-400:#f87171;--red-500:#ef4444;--red-600:#dc2626;--red-700:#b91c1c;--red-800:#991b1b;--red-900:#7f1d1d;--orange-50:#fff7ed;--orange-100:#ffedd5;--orange-200:#fed7aa;--orange-300:#fdba74;--orange-400:#fb923c;--orange-500:#f97316;--orange-600:#ea580c;--orange-700:#c2410c;--orange-800:#9a3412;--orange-900:#7c2d12;--amber-50:#fffbeb;--amber-100:#fef3c7;--amber-200:#fde68a;--amber-300:#fcd34d;--amber-400:#fbbf24;--amber-500:#f59e0b;--amber-600:#d97706;--amber-700:#b45309;--amber-800:#92400e;--amber-900:#78350f;--yellow-50:#fffbeb;--yellow-100:#fef3c7;--yellow-200:#fde68a;--yellow-300:#fcd34d;--yellow-400:#fbbf24;--yellow-500:#f59e0b;--yellow-600:#d97706;--yellow-700:#b45309;--yellow-800:#92400e;--yellow-900:#78350f;--lime-50:#f7fee7;--lime-100:#ecfccb;--lime-200:#d9f99d;--lime-300:#bef264;--lime-400:#a3e635;--lime-500:#84cc16;--lime-600:#65a30d;--lime-700:#4d7c0f;--lime-800:#3f6212;--lime-900:#365314;--green-50:#ecfdf5;--green-100:#d1fae5;--green-200:#a7f3d0;--green-300:#6ee7b7;--green-400:#34d399;--green-500:#10b981;--green-600:#059669;--green-700:#047857;--green-800:#065f46;--green-900:#064e3b;--emerald-50:#ecfdf5;--emerald-100:#d1fae5;--emerald-200:#a7f3d0;--emerald-300:#6ee7b7;--emerald-400:#34d399;--emerald-500:#10b981;--emerald-600:#059669;--emerald-700:#047857;--emerald-800:#065f46;--emerald-900:#064e3b;--teal-50:#f0fdfa;--teal-100:#ccfbf1;--teal-200:#99f6e4;--teal-300:#5eead4;--teal-400:#2dd4bf;--teal-500:#14b8a6;--teal-600:#0d9488;--teal-700:#0f766e;--teal-800:#115e59;--teal-900:#134e4a;--cyan-50:#ecfeff;--cyan-100:#cffafe;--cyan-200:#a5f3fc;--cyan-300:#67e8f9;--cyan-400:#22d3ee;--cyan-500:#06b6d4;--cyan-600:#0891b2;--cyan-700:#0e7490;--cyan-800:#155e75;--cyan-900:#164e63;--sky-50:#f0f9ff;--sky-100:#e0f2fe;--sky-200:#bae6fd;--sky-300:#7dd3fc;--sky-400:#38bdf8;--sky-500:#0ea5e9;--sky-600:#0284c7;--sky-700:#0369a1;--sky-800:#075985;--sky-900:#0c4a6e;--blue-50:#eff6ff;--blue-100:#dbeafe;--blue-200:#bfdbfe;--blue-300:#93c5fd;--blue-400:#60a5fa;--blue-500:#3b82f6;--blue-600:#2563eb;--blue-700:#1d4ed8;--blue-800:#1e40af;--blue-900:#1e3a8a;--indigo-50:#eef2ff;--indigo-100:#e0e7ff;--indigo-200:#c7d2fe;--indigo-300:#a5b4fc;--indigo-400:#818cf8;--indigo-500:#6366f1;--indigo-600:#4f46e5;--indigo-700:#4338ca;--indigo-800:#3730a3;--indigo-900:#312e81;--violet-50:#f5f3ff;--violet-100:#ede9fe;--violet-200:#ddd6fe;--violet-300:#c4b5fd;--violet-400:#a78bfa;--violet-500:#8b5cf6;--violet-600:#7c3aed;--violet-700:#6d28d9;--violet-800:#5b21b6;--violet-900:#4c1d95;--purple-50:#faf5ff;--purple-100:#f3e8ff;--purple-200:#e9d5ff;--purple-300:#d8b4fe;--purple-400:#c084fc;--purple-500:#a855f7;--purple-600:#9333ea;--purple-700:#7e22ce;--purple-800:#6b21a8;--purple-900:#581c87;--fuchsia-50:#fdf4ff;--fuchsia-100:#fae8ff;--fuchsia-200:#f5d0fe;--fuchsia-300:#f0abfc;--fuchsia-400:#e879f9;--fuchsia-500:#d946ef;--fuchsia-600:#c026d3;--fuchsia-700:#a21caf;--fuchsia-800:#86198f;--fuchsia-900:#701a75;--pink-50:#fdf2f8;--pink-100:#fce7f3;--pink-200:#fbcfe8;--pink-300:#f9a8d4;--pink-400:#f472b6;--pink-500:#ec4899;--pink-600:#db2777;--pink-700:#be185d;--pink-800:#9d174d;--pink-900:#831843;--rose-50:#fff1f2;--rose-100:#ffe4e6;--rose-200:#fecdd3;--rose-300:#fda4af;--rose-400:#fb7185;--rose-500:#f43f5e;--rose-600:#e11d48;--rose-700:#be123c;--rose-800:#9f1239;--rose-900:#881337;--gray-50:#f9fafb;--gray-100:#f3f4f6;--gray-200:#e5e7eb;--gray-300:#d1d5db;--gray-400:#9ca3af;--gray-500:#6b7280;--gray-600:#4b5563;--gray-700:#374151;--gray-800:#1f2937;--gray-900:#111827}@font-face{font-family:'Inter';font-style:normal;font-weight:400;font-display:swap;src:url(https://fonts.gstatic.com/s/inter/v12/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuLyfAZ9hiA.woff2) format('woff2');unicode-range:U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD}*{box-sizing:border-box;font-family:'Inter', 'Inter UI', Roboto, 'Segoe UI', Helvetica, Arial, sans-serif !important}html,body{margin:0 !important;padding:0 !important;font-family:'Inter', 'Inter UI', Roboto, 'Segoe UI', Helvetica, Arial, sans-serif;}.provider{display:flex;flex-direction:column;width:100%;height:100%;margin:0;padding:0;font-family:'Inter', 'Inter UI', Roboto, 'Segoe UI', Helvetica, Arial, sans-serif;background-color:var(--containerMain);color:var(--textPrimary);transition:background-color 0.2s ease-in-out, color 0.2s ease-in-out, fill 0.2s ease-in-out}.provider--darkTheme{--containerMain:var(--slate-800);--containerSecondary:var(--slate-900);--containerTertiary:var(--slate-700);--textPrimary:var(--neutral-50);--textSecondary:var(--gray-300);--textTertiary:var(--gray-400);--primary:var(--blue-700);--secondary:var(--blue-800);--tertiary:var(--blue-600);--success:var(--green-700);--textOnSuccess:var(--neutral-50);--error:var(--red-700);--textOnError:var(--neutral-50);--warning:var(--yellow-700);--textOnWarning:var(--neutral-900);--info:var(--blue-700);--textOnInfo:var(--neutral-50);--danger:var(--red-700);--textOnDanger:var(--neutral-50);--white:#ffffff;--black:#000000}.provider--lightTheme{--containerMain:var(--slate-50);--containerSecondary:var(--gray-300);--containerTertiary:var(--gray-200);--textPrimary:var(--neutral-900);--textSecondary:var(--neutral-800);--textTertiary:var(--neutral-700);--primary:var(--blue-400);--secondary:var(--blue-300);--tertiary:var(--blue-500);--success:var(--green-400);--textOnSuccess:var(--neutral-900);--error:var(--red-400);--textOnError:var(--neutral-900);--warning:var(--yellow-400);--textOnWarning:var(--neutral-900);--info:var(--blue-400);--textOnInfo:var(--neutral-900);--danger:var(--red-400);--textOnDanger:var(--neutral-900);--white:#ffffff;--black:#000000}.elevation-1{box-shadow:0px 0px 10px rgba(0, 0, 0)}.elevation-2{box-shadow:0px 0px 10px rgba(0, 0, 0, 0.2)}.elevation-3{box-shadow:0px 0px 10px rgba(0, 0, 0, 0.4)}.elevation-4{box-shadow:0px 0px 10px rgba(0, 0, 0, 0.6)}.elevation-5{box-shadow:0px 0px 10px rgba(0, 0, 0, 0.8)}.elevation-6{box-shadow:0px 0px 10px rgba(0, 0, 0, 1)}.debugBox{display:flex;flex-direction:column;position:fixed;top:10px;right:10px;width:fit-content;height:fit-content;background-color:var(--containerTertiary);border-radius:7px;padding:5px;z-index:9999}.mediaBox{display:flex;flex-direction:row;position:fixed;bottom:10px;right:10px;width:fit-content;height:fit-content;padding:5px;z-index:9999}";

const MyComponent = /*@__PURE__*/ proxyCustomElement(class extends HTMLElement {
  constructor() {
    super();
    this.__registerHost();
    this.darkTheme = false;
    this.debugMode = undefined;
    this.customTheme = {
      name: 'default',
      colors: {}
    };
  }
  // a function that changes the theme
  changeTheme(theme) {
    if (theme === 'dark') {
      this.darkTheme = true;
    }
    else if (theme === 'light') {
      this.darkTheme = false;
    }
    else {
      this.darkTheme = !this.darkTheme;
    }
    return this.darkTheme;
  }
  render() {
    return (h("div", { style: this.customTheme.name != 'default' ? this.customTheme.colors : '', class: `provider ${this.darkTheme ? 'provider--darkTheme' : 'provider--lightTheme'}` }, this.debugMode ? (h("div", { id: "debugModeContainer" }, h("div", { class: "debugBox" }, h("span", null, "UXLibrary v", buildVersion), h("ux-button", { onClick: () => this.changeTheme() }, "Change theme")), h("div", { class: "mediaBox" }, h("ux-button", { prependIcon: "github", onClick: () => redirectToGithub() }, "Github")))) : null, h("slot", null)));
  }
  static get style() { return uxProviderCss; }
}, [4, "ux-provider", {
    "darkTheme": [1028, "dark-theme"],
    "debugMode": [1028, "debug-mode"],
    "customTheme": [8, "custom-theme"]
  }]);
function defineCustomElement() {
  if (typeof customElements === "undefined") {
    return;
  }
  const components = ["ux-provider", "ux-button", "ux-icon"];
  components.forEach(tagName => { switch (tagName) {
    case "ux-provider":
      if (!customElements.get(tagName)) {
        customElements.define(tagName, MyComponent);
      }
      break;
    case "ux-button":
      if (!customElements.get(tagName)) {
        defineCustomElement$2();
      }
      break;
    case "ux-icon":
      if (!customElements.get(tagName)) {
        defineCustomElement$1();
      }
      break;
  } });
}

export { MyComponent as M, defineCustomElement as d, getDataComponents as g };
