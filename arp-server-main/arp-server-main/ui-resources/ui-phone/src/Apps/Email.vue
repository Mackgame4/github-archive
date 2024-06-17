<template>
    <div class="app">
        <div class="header simpleAppHeader">
            <v-subheader>Mail Box - {{ getMyName }} </v-subheader>
            <v-spacer></v-spacer>
            <div class="headerButton" v-if="!viewingEmail">
                <!--v-btn class="innerButton" icon small @click="startEmailCompose">
                    <v-icon size="18">mdi-email-plus</v-icon>
                </v-btn!-->
            </div>
        </div>
        <div class="subContainer" v-if="viewingEmail">
            <div class="mailInfo grey--text text--lighten-4">
                <p><b>From</b>: {{ viewingEmail.mailer }}</p>
                <p><b>Recieved</b>: {{ getHumanFormattedTime(viewingEmail.time) }}</p>
                <p class="subject"><b>Subject:</b> {{ viewingEmail.subject }}</p>
            </div>
            <div class="mailBody">
                <p v-text="viewingEmail.body"></p>
                <!--editor-content class="editor__content" :editor="mailEditor" /!-->
            </div>
        </div>
        <!--div class="subContainer" v-else-if="composingEmail">
            <div class="mailOptions">
                <v-text-field color="red darken-4" label="Email"></v-text-field>

            </div>
            <div class="mailCompose">
                <editor-menu-bar :editor="mailEditor" v-slot="{ commands, isActive }">
                    <div class="menubar" style="height: 15%; margin: 0;">
                        <div class="toolbar">
                            <v-btn icon small @click="commands.undo">
                                <v-icon size="18">mdi-undo</v-icon>
                            </v-btn>

                            <v-btn icon small @click="commands.redo">
                                <v-icon size="18">mdi-redo</v-icon>
                            </v-btn>

                            <v-btn icon :color="isActive.bold() ? 'red darken-4' : ''" small @click="commands.bold">
                                <v-icon size="18">mdi-format-bold</v-icon>
                            </v-btn>

                            <v-btn icon :color="isActive.italic() ? 'red darken-4' : ''" small @click="commands.italic">
                                <v-icon size="18">mdi-format-italic</v-icon>
                            </v-btn>

                            <v-btn icon :color="isActive.strike() ? 'red darken-4' : ''" small @click="commands.strike">
                                <v-icon size="18">mdi-format-strikethrough</v-icon>
                            </v-btn>

                            <v-btn icon :color="isActive.underline() ? 'red darken-4' : ''" small @click="commands.underline">
                                <v-icon size="18">mdi-format-underline</v-icon>
                            </v-btn>

                            <v-btn icon :color="isActive.code() ? 'red darken-4' : ''" small @click="commands.code">
                                <v-icon size="18">mdi-code-tags</v-icon>
                            </v-btn>

                            <v-btn icon :color="isActive.paragraph() ? 'red darken-4' : ''" small @click="commands.paragraph">
                                <v-icon size="18">mdi-format-paragraph</v-icon>
                            </v-btn>

                            <v-btn icon :color="isActive.heading({ level: 1 }) ? 'red darken-4' : ''" small @click="commands.heading({ level: 1 })">
                                <v-icon size="18">mdi-format-header-1</v-icon>
                            </v-btn>

                            <v-btn icon :color="isActive.heading({ level: 2 }) ? 'red darken-4' : ''" small @click="commands.heading({ level: 2 })">
                                <v-icon size="18">mdi-format-header-2</v-icon>
                            </v-btn>

                            <v-btn icon :color="isActive.heading({ level: 3 }) ? 'red darken-4' : ''" small @click="commands.heading({ level: 3 })">
                                <v-icon size="18">mdi-format-header-3</v-icon>
                            </v-btn>

                            <v-btn icon :color="isActive.heading({ level: 4 }) ? 'red darken-4' : ''" small @click="commands.heading({ level: 4 })">
                                <v-icon size="18">mdi-format-header-4</v-icon>
                            </v-btn>

                            <v-btn icon :color="isActive.bullet_list()  ? 'red darken-4' : ''" small @click="commands.bullet_list">
                                <v-icon size="18">mdi-format-list-bulleted</v-icon>
                            </v-btn>

                            <v-btn icon :color="isActive.ordered_list()  ? 'red darken-4' : ''" small @click="commands.ordered_list">
                                <v-icon size="18">mdi-format-list-numbered</v-icon>
                            </v-btn>

                            <v-btn icon :color="isActive.blockquote()  ? 'red darken-4' : ''" small @click="commands.blockquote">
                                <v-icon size="18">mdi-format-quote-open</v-icon>
                            </v-btn>

                            <v-btn icon :color="isActive.code_block()  ? 'red darken-4' : ''" small @click="commands.code_block">
                                <v-icon size="18">mdi-file-code</v-icon>
                            </v-btn>

                            <v-btn icon small @click="commands.createTable({rowsCount: 3, colsCount: 3, withHeaderRow: false })">
                                <v-icon size="18">mdi-table-plus</v-icon>
                            </v-btn>

                            <v-btn icon small v-if="isActive.table()" @click="commands.deleteTable">
                                <v-icon size="18">mdi-table-remove</v-icon>
                            </v-btn>

                            <v-btn icon small v-if="isActive.table()" @click="commands.addColumnBefore">
                                <v-icon size="18">mdi-table-column-plus-before</v-icon>
                            </v-btn>

                            <v-btn icon small v-if="isActive.table()" @click="commands.addColumnAfter">
                                <v-icon size="18">mdi-table-column-plus-after</v-icon>
                            </v-btn>

                            <v-btn icon small v-if="isActive.table()" @click="commands.deleteColumn">
                                <v-icon size="18">mdi-table-column-remove</v-icon>
                            </v-btn>

                            <v-btn icon small v-if="isActive.table()" @click="commands.addRowBefore">
                                <v-icon size="18">mdi-table-row-plus-before</v-icon>
                            </v-btn>

                            <v-btn icon small v-if="isActive.table()" @click="commands.addRowAfter">
                                <v-icon size="18">mdi-table-row-plus-after</v-icon>
                            </v-btn>

                            <v-btn icon small v-if="isActive.table()" @click="commands.deleteRow">
                                <v-icon size="18">mdi-table-row-remove</v-icon>
                            </v-btn>

                            <v-btn icon small v-if="isActive.table()" @click="commands.toggleCellMerge">
                                <v-icon size="18">mdi-table-merge-cells</v-icon>
                            </v-btn>
                        </div>
                    </div>
                </editor-menu-bar>
                <div class="mailComposeBody">
                    <editor-content class="editor__content" :editor="mailEditor" />
                </div>
            </div>
        </div!-->
        <div class="subContainer" v-else>
            <v-list subheader flat class="list">
                <v-list-item v-if="getEmails.length === 0">
                    <v-list-item-content>
                        <v-list-item-title>No Emails</v-list-item-title>
                        <v-list-item-subtitle>There are no emails to show</v-list-item-subtitle>
                    </v-list-item-content>
                </v-list-item>

                <v-list-item link v-for="email in getEmails" v-bind:key="email.id" @click="viewEmail(email.id)">
                    <v-list-item-content>
                        <v-list-item-title>{{ email.subject }}</v-list-item-title>
                        <v-list-item-subtitle><strong>{{ email.mailer }}</strong> - {{ getHumanFormattedTime(email.time) }}</v-list-item-subtitle>
                    </v-list-item-content>
                </v-list-item>
            </v-list>
        </div>
    </div>
</template>

<script>
//import Nui from '../../utils/Nui';
import moment from 'moment';
/*import { Editor, EditorContent, EditorMenuBar } from 'tiptap';
import {
    Blockquote,
    CodeBlock,
    HardBreak,
    Heading,
    HorizontalRule,
    OrderedList,
    BulletList,
    ListItem,
    TodoItem,
    TodoList,
    Bold,
    Code,
    Italic,
    Link,
    Strike,
    Underline,
    History,
    Table,
    TableHeader,
    TableCell,
    TableRow,
} from 'tiptap-extensions';*/

export default {
    name: 'Email',
    components: {
        //EditorContent,
        //EditorMenuBar,
    },
    data: () => ({
        viewingEmail: false,
        composingEmail: false,
        /*mailEditor: new Editor({
            extensions: [
                new Blockquote(),
                new BulletList(),
                new HardBreak(),
                new Heading({ levels: [1, 2, 3, 4] }),
                new HorizontalRule(),
                new ListItem(),
                new OrderedList(),
                new Link(),
                new Bold(),
                new Code(),
                new CodeBlock(),
                new Italic(),
                new Strike(),
                new Underline(),
                new History(),
                new Table({
                    resizable: true,
                }),
                new TableHeader(),
                new TableCell(),
                new TableRow(),
            ],
            content: `
                <h2>
                    Export HTML or JSON
                </h2>
                <p>
                    You are able to export your data as <code>HTML</code> or <code>JSON</code>.
                </p>
            `,
            editable: false,
        }),*/
    }),
    props: {},
    methods: {
        goBack() {
            if (this.viewingEmail) {
                this.closeEmail();
            } else if (this.composingEmail) {
                this.composingEmail = false;
            }
        },
        getHumanFormattedTime(time) {
            return moment.unix(time).fromNow();
        },
        viewEmail(id) {
            this.viewingEmail = this.$store.getters.getEmail(id);
            //this.mailEditor.setContent(JSON.parse(this.viewingEmail.body));
            //this.mailEditor.setOptions({ editable: false });
            //this.mailEditor.focus()
        },
        closeEmail() {
            this.viewingEmail = false;
        },
        /*startEmailCompose() {
            if (!this.viewingEmail) {
                this.mailEditor.setOptions({ editable: true });
                this.mailEditor.focus()
                this.composingEmail = true;
            }
        }*/
    },
    computed: {
        getMyName() {
            return this.$store.getters.getName;
        },
        getEmails() {
            return this.$store.getters.getEmails;
        },
    },
    created() {

    },
    mounted() {
        this.$root.$on('goBack', this.goBack);
    },
    beforeDestroy() {
        this.$root.$off('goBack', this.goBack);
    }
};

</script>
<style scoped lang="less">
@import '@/arp-theme.less';


.app {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;

    .subContainer {
        height: 94%;
        overflow: hidden;
        .list {
            height: 100%;
            overflow-y: scroll;
        }

        .mailInfo {
            height: 18%;
            padding: 0 5% 5%;
            p { 
                margin: 0;
                overflow: hidden;
            }
            .subject {
                display: -webkit-box;
                -webkit-line-clamp: 2; /* number of lines to show */
                -webkit-box-orient: vertical;
            }
        }
        .mailBody {
            height: 82%;
            padding: 5%;
            color: white;
            overflow-y: scroll;
            word-break: break-all;
            width: 100%;
        }

        .mailOptions {
            height: 15%;
            padding: 0 5%;
        }

        .mailCompose {
            height: 70%;
            display: flex;
            flex-direction: column;
            .toolbar {
                height: 100%;
                width: 90%;
                margin-left: 5%;
                display: grid;
                grid-template-columns: repeat(9, 11.1111%);
                grid-template-rows: repeat(3, 33.3%);
            }
            .mailComposeBody {
                overflow-y: scroll;
                padding: 5%;
            }
        }
    }
}

</style>

<style lang="scss">
$color-black: #000000;
$color-white: #ffffff;
$color-grey: #dddddd;

.menubar {

  margin-bottom: 1rem;
  transition: visibility 0.2s 0.4s, opacity 0.2s 0.4s;

  &.is-hidden {
    visibility: hidden;
    opacity: 0;
  }

  &.is-focused {
    visibility: visible;
    opacity: 1;
    transition: visibility 0.2s, opacity 0.2s;
  }

  &__button {
    font-weight: bold;
    display: inline-flex;
    background: transparent;
    border: 0;
    color: #000000;
    padding: 0.2rem 0.5rem;
    margin-right: 0.2rem;
    border-radius: 3px;
    cursor: pointer;

    &:hover {
      background-color: rgba(0, 0, 0, 0.05);
    }

    &.is-active {
      background-color: rgba(0, 0, 0, 0.556);
    }
  }

  span#{&}__button {
    font-size: 13.3333px;
  }
}

.editor {
  position: relative;
  max-width: 30rem;
  margin: 0 auto 5rem auto;

  &__content {

    overflow-wrap: break-word;
    word-wrap: break-word;
    word-break: break-word;

    h1,
    h2,
    h3,
    p,
    ul,
    ol,
    pre,
        blockquote {
        margin: 1rem 0;

        &:first-child {
            margin-top: 0;
        }

        &:last-child {
            margin-bottom: 0;
        }
    }

    h1,
    h2,
    h3 {
        line-height: 1.3;
    }

    * {
        caret-color: currentColor;
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        text-size-adjust: 100%;
        -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
        -webkit-touch-callout: none;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
        text-rendering: optimizeLegibility;
        line-height: 1.5;
    }

    *::before,
        *::after {
        box-sizing: border-box;
        }





    pre {
      padding: 0.7rem 1rem;
      border-radius: 5px;
      background: $color-black;
      color: $color-white;
      font-size: 0.8rem;
      overflow-x: auto;

      code {
        display: block;
        background: transparent !important;
      }
    }

    p code {
      padding: 0.2rem 0.4rem;
      border-radius: 5px;
      font-size: 0.8rem;
      font-weight: bold;
      background: rgba($color-black, 0.1);
      color: rgba($color-black, 0.8);
    }

    ul,
    ol {
      padding-left: 1rem;
    }

    li > p,
    li > ol,
    li > ul {
      margin: 0;
    }

    a {
      color: inherit;
    }

    blockquote {
      border-left: 3px solid $color-black;
      color: rgba($color-white, 0.8);
      padding-left: 0.8rem;
      font-style: italic;

      p {
        margin: 0;
      }
    }

    img {
      max-width: 100%;
      border-radius: 3px;
    }

    table {
      border-collapse: collapse;
      table-layout: fixed;
      width: 100%;
      margin: 0;
      overflow: hidden;

      td, th {
        min-width: 1em;
        border: 2px solid $color-grey;
        padding: 3px 5px;
        vertical-align: top;
        box-sizing: border-box;
        position: relative;
        > * {
          margin-bottom: 0;
        }
      }

      th {
        font-weight: bold;
        text-align: left;
      }

      .selectedCell:after {
        z-index: 2;
        position: absolute;
        content: "";
        left: 0; right: 0; top: 0; bottom: 0;
        background: rgba(200, 200, 255, 0.4);
        pointer-events: none;
      }

      .column-resize-handle {
        position: absolute;
        right: -2px; top: 0; bottom: 0;
        width: 4px;
        z-index: 20;
        background-color: #adf;
        pointer-events: none;
      }
    }

    .tableWrapper {
      margin: 1em 0;
      overflow-x: auto;
    }

    .resize-cursor {
      cursor: ew-resize;
      cursor: col-resize;
    }

  }
}
</style>