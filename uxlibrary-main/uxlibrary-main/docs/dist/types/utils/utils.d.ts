export declare const debugMode: boolean;
export declare const buildVersion = "1.0.0";
export declare function log(message: string, ...args: any[]): string;
export declare function getDataComponents(): {
  timestamp: string;
  compiler: {
    name: string;
    version: string;
    typescriptVersion: string;
  };
  components: ({
    filePath: string;
    encapsulation: string;
    tag: string;
    readme: string;
    docs: string;
    docsTags: any[];
    usage: {};
    props: ({
      name: string;
      type: string;
      mutable: boolean;
      attr: string;
      reflectToAttr: boolean;
      docs: string;
      docsTags: any[];
      values: {
        type: string;
      }[];
      optional: boolean;
      required: boolean;
      default?: undefined;
    } | {
      name: string;
      type: string;
      mutable: boolean;
      attr: string;
      reflectToAttr: boolean;
      docs: string;
      docsTags: any[];
      default: string;
      values: {
        type: string;
      }[];
      optional: boolean;
      required: boolean;
    })[];
    methods: any[];
    events: any[];
    listeners: any[];
    styles: any[];
    slots: any[];
    parts: any[];
    dependents: any[];
    dependencies: string[];
    dependencyGraph: {
      "ux-badge": string[];
      "ux-button"?: undefined;
      "ux-playground"?: undefined;
      "ux-provider"?: undefined;
      "ux-video"?: undefined;
      "ux-select"?: undefined;
      "ux-textinput"?: undefined;
      "ux-otp"?: undefined;
    };
  } | {
    filePath: string;
    encapsulation: string;
    tag: string;
    readme: string;
    docs: string;
    docsTags: any[];
    usage: {};
    props: ({
      name: string;
      type: string;
      mutable: boolean;
      attr: string;
      reflectToAttr: boolean;
      docs: string;
      docsTags: any[];
      values: {
        type: string;
      }[];
      optional: boolean;
      required: boolean;
      default?: undefined;
    } | {
      name: string;
      type: string;
      mutable: boolean;
      attr: string;
      reflectToAttr: boolean;
      docs: string;
      docsTags: any[];
      default: string;
      values: {
        type: string;
      }[];
      optional: boolean;
      required: boolean;
    })[];
    methods: any[];
    events: any[];
    listeners: any[];
    styles: any[];
    slots: any[];
    parts: any[];
    dependents: string[];
    dependencies: string[];
    dependencyGraph: {
      "ux-button": string[];
      "ux-playground": string[];
      "ux-provider": string[];
      "ux-video": string[];
      "ux-badge"?: undefined;
      "ux-select"?: undefined;
      "ux-textinput"?: undefined;
      "ux-otp"?: undefined;
    };
  } | {
    filePath: string;
    encapsulation: string;
    tag: string;
    readme: string;
    docs: string;
    docsTags: any[];
    usage: {};
    props: {
      name: string;
      type: string;
      mutable: boolean;
      attr: string;
      reflectToAttr: boolean;
      docs: string;
      docsTags: any[];
      default: string;
      values: {
        type: string;
      }[];
      optional: boolean;
      required: boolean;
    }[];
    methods: any[];
    events: any[];
    listeners: any[];
    styles: any[];
    slots: any[];
    parts: any[];
    dependents: string[];
    dependencies: any[];
    dependencyGraph: {
      "ux-badge": string[];
      "ux-button": string[];
      "ux-select": string[];
      "ux-textinput": string[];
      "ux-video": string[];
      "ux-playground"?: undefined;
      "ux-provider"?: undefined;
      "ux-otp"?: undefined;
    };
  } | {
    filePath: string;
    encapsulation: string;
    tag: string;
    readme: string;
    docs: string;
    docsTags: any[];
    usage: {};
    props: ({
      name: string;
      type: string;
      mutable: boolean;
      attr: string;
      reflectToAttr: boolean;
      docs: string;
      docsTags: any[];
      default: string;
      values: {
        type: string;
      }[];
      optional: boolean;
      required: boolean;
    } | {
      name: string;
      type: string;
      mutable: boolean;
      attr: string;
      reflectToAttr: boolean;
      docs: string;
      docsTags: any[];
      values: {
        type: string;
      }[];
      optional: boolean;
      required: boolean;
      default?: undefined;
    } | {
      name: string;
      type: string;
      mutable: boolean;
      reflectToAttr: boolean;
      docs: string;
      docsTags: any[];
      values: {
        type: string;
      }[];
      optional: boolean;
      required: boolean;
      attr?: undefined;
      default?: undefined;
    })[];
    methods: any[];
    events: {
      event: string;
      detail: string;
      bubbles: boolean;
      cancelable: boolean;
      composed: boolean;
      docs: string;
      docsTags: any[];
    }[];
    listeners: any[];
    styles: any[];
    slots: any[];
    parts: any[];
    dependents: any[];
    dependencies: string[];
    dependencyGraph: {
      "ux-otp": string[];
      "ux-textinput": string[];
      "ux-badge"?: undefined;
      "ux-button"?: undefined;
      "ux-playground"?: undefined;
      "ux-provider"?: undefined;
      "ux-video"?: undefined;
      "ux-select"?: undefined;
    };
  } | {
    filePath: string;
    encapsulation: string;
    tag: string;
    readme: string;
    docs: string;
    docsTags: any[];
    usage: {};
    props: any[];
    methods: any[];
    events: any[];
    listeners: any[];
    styles: any[];
    slots: any[];
    parts: any[];
    dependents: any[];
    dependencies: string[];
    dependencyGraph: {
      "ux-playground": string[];
      "ux-provider": string[];
      "ux-button": string[];
      "ux-select": string[];
      "ux-textinput": string[];
      "ux-badge"?: undefined;
      "ux-video"?: undefined;
      "ux-otp"?: undefined;
    };
  } | {
    filePath: string;
    encapsulation: string;
    tag: string;
    readme: string;
    docs: string;
    docsTags: any[];
    usage: {};
    props: ({
      name: string;
      type: string;
      mutable: boolean;
      attr: string;
      reflectToAttr: boolean;
      docs: string;
      docsTags: any[];
      default: string;
      values: {
        type: string;
      }[];
      optional: boolean;
      required: boolean;
    } | {
      name: string;
      type: string;
      mutable: boolean;
      attr: string;
      reflectToAttr: boolean;
      docs: string;
      docsTags: any[];
      values: {
        type: string;
      }[];
      optional: boolean;
      required: boolean;
      default?: undefined;
    })[];
    methods: any[];
    events: any[];
    listeners: any[];
    styles: any[];
    slots: any[];
    parts: any[];
    dependents: string[];
    dependencies: string[];
    dependencyGraph: {
      "ux-provider": string[];
      "ux-button": string[];
      "ux-playground": string[];
      "ux-badge"?: undefined;
      "ux-video"?: undefined;
      "ux-select"?: undefined;
      "ux-textinput"?: undefined;
      "ux-otp"?: undefined;
    };
  } | {
    filePath: string;
    encapsulation: string;
    tag: string;
    readme: string;
    docs: string;
    docsTags: any[];
    usage: {};
    props: ({
      name: string;
      type: string;
      mutable: boolean;
      attr: string;
      reflectToAttr: boolean;
      docs: string;
      docsTags: any[];
      default: string;
      values: {
        type: string;
      }[];
      optional: boolean;
      required: boolean;
    } | {
      name: string;
      type: string;
      mutable: boolean;
      attr: string;
      reflectToAttr: boolean;
      docs: string;
      docsTags: any[];
      values: {
        type: string;
      }[];
      optional: boolean;
      required: boolean;
      default?: undefined;
    })[];
    methods: any[];
    events: {
      event: string;
      detail: string;
      bubbles: boolean;
      cancelable: boolean;
      composed: boolean;
      docs: string;
      docsTags: any[];
    }[];
    listeners: any[];
    styles: any[];
    slots: any[];
    parts: any[];
    dependents: string[];
    dependencies: string[];
    dependencyGraph: {
      "ux-select": string[];
      "ux-playground": string[];
      "ux-badge"?: undefined;
      "ux-button"?: undefined;
      "ux-provider"?: undefined;
      "ux-video"?: undefined;
      "ux-textinput"?: undefined;
      "ux-otp"?: undefined;
    };
  } | {
    filePath: string;
    encapsulation: string;
    tag: string;
    readme: string;
    docs: string;
    docsTags: any[];
    usage: {};
    props: {
      name: string;
      type: string;
      mutable: boolean;
      attr: string;
      reflectToAttr: boolean;
      docs: string;
      docsTags: any[];
      default: string;
      values: {
        type: string;
      }[];
      optional: boolean;
      required: boolean;
    }[];
    methods: any[];
    events: {
      event: string;
      detail: string;
      bubbles: boolean;
      cancelable: boolean;
      composed: boolean;
      docs: string;
      docsTags: any[];
    }[];
    listeners: any[];
    styles: any[];
    slots: any[];
    parts: any[];
    dependents: any[];
    dependencies: any[];
    dependencyGraph: {
      "ux-badge"?: undefined;
      "ux-button"?: undefined;
      "ux-playground"?: undefined;
      "ux-provider"?: undefined;
      "ux-video"?: undefined;
      "ux-select"?: undefined;
      "ux-textinput"?: undefined;
      "ux-otp"?: undefined;
    };
  } | {
    filePath: string;
    encapsulation: string;
    tag: string;
    readme: string;
    docs: string;
    docsTags: any[];
    usage: {};
    props: ({
      name: string;
      type: string;
      mutable: boolean;
      attr: string;
      reflectToAttr: boolean;
      docs: string;
      docsTags: any[];
      values: {
        type: string;
      }[];
      optional: boolean;
      required: boolean;
      default?: undefined;
    } | {
      name: string;
      type: string;
      mutable: boolean;
      attr: string;
      reflectToAttr: boolean;
      docs: string;
      docsTags: any[];
      default: string;
      values: {
        type: string;
      }[];
      optional: boolean;
      required: boolean;
    })[];
    methods: any[];
    events: {
      event: string;
      detail: string;
      bubbles: boolean;
      cancelable: boolean;
      composed: boolean;
      docs: string;
      docsTags: any[];
    }[];
    listeners: any[];
    styles: any[];
    slots: any[];
    parts: any[];
    dependents: string[];
    dependencies: string[];
    dependencyGraph: {
      "ux-textinput": string[];
      "ux-otp": string[];
      "ux-playground": string[];
      "ux-badge"?: undefined;
      "ux-button"?: undefined;
      "ux-provider"?: undefined;
      "ux-video"?: undefined;
      "ux-select"?: undefined;
    };
  } | {
    filePath: string;
    encapsulation: string;
    tag: string;
    readme: string;
    docs: string;
    docsTags: any[];
    usage: {};
    props: {
      name: string;
      type: string;
      mutable: boolean;
      attr: string;
      reflectToAttr: boolean;
      docs: string;
      docsTags: any[];
      default: string;
      values: {
        type: string;
      }[];
      optional: boolean;
      required: boolean;
    }[];
    methods: any[];
    events: any[];
    listeners: any[];
    styles: any[];
    slots: any[];
    parts: any[];
    dependents: any[];
    dependencies: string[];
    dependencyGraph: {
      "ux-video": string[];
      "ux-button": string[];
      "ux-badge"?: undefined;
      "ux-playground"?: undefined;
      "ux-provider"?: undefined;
      "ux-select"?: undefined;
      "ux-textinput"?: undefined;
      "ux-otp"?: undefined;
    };
  })[];
};
export declare function redirectToGithub(): void;
