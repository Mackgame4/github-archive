<template>
    <div id="app">
        <v-app>
            <div class="appBar">
                <!-- Global App Bar -->
                <v-tabs v-model="tab" fixed-tabs dark>
                    <v-tab href="#tab-1"><v-icon>mdi-home</v-icon></v-tab>
                    <v-tab href="#tab-2"><v-icon>mdi-heart</v-icon></v-tab>
                    <v-tab href="#tab-3"><v-icon>mdi-account</v-icon></v-tab>
                </v-tabs>
            </div>
            <div class="appContainer">
                <!-- Home Tab -->
                <div v-if="tab == 'tab-1'">
                    <!-- Sticked Posts -->
                    <div v-for="(post, id) in twitterPosts" :key="id">
                        <v-card v-if="post.sticked" class="post" dark>
                            <v-btn style="position: absolute; right: 10px; top: 6px;" icon color="grey darken-1" :disabled="!isUserAnAdmin" @click='post.sticked=false' v-if="post.sticked==true"><v-icon>mdi-pin</v-icon></v-btn>
                            <v-card-title><v-avatar size="25"><img src="https://cdn.vuetifyjs.com/images/john.jpg"></v-avatar>‏‏‎ ‎‏‏‎ ‎{{ post.author }}</v-card-title>
                            <v-card-subtitle>{{ post.text }}</v-card-subtitle>
                            <v-img v-if="isUriImage" :src="post.text"></v-img>
                            <v-card-actions>
                                <div>
                                    <v-btn icon color="red darken-1" @click='post.likesCount-=1' v-if="post.likesCount>0"><v-icon>mdi-heart</v-icon>{{post.likesCount}}</v-btn>
                                    <v-btn icon color="red darken-1" @click='post.likesCount+=1' v-if="post.likesCount<=0"><v-icon>mdi-heart-outline</v-icon></v-btn>
                                    <v-btn icon color="info darken-1" @click='post.archived=false' v-if="post.archived==true"><v-icon>mdi-archive</v-icon></v-btn>
                                    <v-btn icon color="info darken-1" @click='post.archived=true' v-if="post.archived==false"><v-icon>mdi-archive-outline</v-icon></v-btn>
                                    <v-text-field class="commentTextField" label="Comment" append-icon="mdi-twitter" @click:append="sendComment()"></v-text-field>
                                </div>
                            </v-card-actions>
                        </v-card>
                    </div>
                    <!-- Home Posts -->
                    <v-card v-for="(post, id) in sortedByDate" :key="`${id}-${post.id}`" class="post" dark>
                        <v-btn style="position: absolute; right: 10px; top: 6px;" icon color="grey darken-1" :disabled="!isUserAnAdmin" @click='post.sticked=true' v-if="isUserAnAdmin && post.sticked==false"><v-icon>mdi-pin-outline</v-icon></v-btn>
                        <v-card-title><v-avatar size="25"><img src="https://cdn.vuetifyjs.com/images/john.jpg"></v-avatar>‏‏‎ ‎‏‏‎ ‎{{ post.author }}</v-card-title>
                        <v-card-subtitle>{{ post.text }}</v-card-subtitle>
                        <v-img v-if="isUriImage" :src="post.text"></v-img>
                        <v-card-actions>
                            <div>
                                <v-btn icon color="red darken-1" @click='post.likesCount-=1' v-if="post.likesCount>0"><v-icon>mdi-heart</v-icon>{{post.likesCount}}</v-btn>
                                <v-btn icon color="red darken-1" @click='post.likesCount+=1' v-if="post.likesCount<=0"><v-icon>mdi-heart-outline</v-icon></v-btn>
                                <v-btn icon color="info darken-1" @click='post.archived=false' v-if="post.archived==true"><v-icon>mdi-archive</v-icon></v-btn>
                                <v-btn icon color="info darken-1" @click='post.archived=true' v-if="post.archived==false"><v-icon>mdi-archive-outline</v-icon></v-btn>
                                <v-text-field class="commentTextField" label="Comment" append-icon="mdi-twitter" @click:append="sendComment()"></v-text-field>
                            </div>
                        </v-card-actions>
                        <!-- Home Posts Comments -->
                        <v-card v-for="(commentPost, id) in post.comments" :key="id" class="comment" dark>
                            <v-card-title><v-avatar size="25"><img src="https://cdn.vuetifyjs.com/images/john.jpg"></v-avatar>‏‏‎ ‎‏‏‎ ‎@{{ commentPost.author }} responded</v-card-title>
                            <v-card-subtitle>{{ commentPost.comment }}</v-card-subtitle>
                            <v-img v-if="isUriImage" :src="commentPost.comment"></v-img>
                            <v-card-actions>
                                <div>
                                    <v-btn icon color="red darken-1" @click='commentPost.likesCount-=1' v-if="commentPost.likesCount>0"><v-icon>mdi-heart</v-icon>{{commentPost.likesCount}}</v-btn>
                                    <v-btn icon color="red darken-1" @click='commentPost.likesCount+=1' v-if="commentPost.likesCount<=0"><v-icon>mdi-heart-outline</v-icon></v-btn>
                                    <v-text-field class="respondTextField" label="Respond" append-icon="mdi-send" @click:append="sendComment()"></v-text-field>
                                </div>
                            </v-card-actions>
                        </v-card>
                    </v-card>
                </div>
                <!-- Most Liked Tab -->
                <div v-if="tab == 'tab-2'">
                    <!-- Most Liked Posts -->
                    <v-card v-for="(post, id) in sortedByLikes" :key="`${id}-${post.id}`" class="post" dark>
                        <v-card-title><v-avatar size="25"><img src="https://cdn.vuetifyjs.com/images/john.jpg"></v-avatar>‏‏‎ ‎‏‏‎ ‎{{ post.author }}</v-card-title>
                        <v-card-subtitle>{{ post.text }}</v-card-subtitle>
                        <v-img v-if="isUriImage" :src="post.text"></v-img>
                        <v-card-actions>
                            <div>
                                <v-btn icon color="red darken-1" @click='post.likesCount+=1' v-if="post.likesCount>0"><v-icon>mdi-heart</v-icon>{{post.likesCount}}</v-btn>
                                <v-btn icon color="red darken-1" @click='post.likesCount+=1' v-if="post.likesCount<=0"><v-icon>mdi-heart-outline</v-icon></v-btn>
                                <v-btn icon color="info darken-1" @click='post.archived=false' v-if="post.archived==true"><v-icon>mdi-archive</v-icon></v-btn>
                                <v-btn icon color="info darken-1" @click='post.archived=true' v-if="post.archived==false"><v-icon>mdi-archive-outline</v-icon></v-btn>
                                <v-text-field class="commentTextField" label="Comment" append-icon="mdi-twitter" @click:append="sendComment()"></v-text-field>
                            </div>
                        </v-card-actions>
                        <!-- Most Liked Posts Comments -->
                        <v-card v-for="(commentPost, id) in post.comments" :key="id" class="comment" dark>
                            <v-card-title><v-avatar size="25"><img src="https://cdn.vuetifyjs.com/images/john.jpg"></v-avatar>‏‏‎ ‎‏‏‎ ‎@{{ commentPost.author }} responded</v-card-title>
                            <v-card-subtitle>{{ commentPost.comment }}</v-card-subtitle>
                            <v-img v-if="isUriImage" :src="commentPost.comment"></v-img>
                            <v-card-actions>
                                <div>
                                    <v-btn icon color="red darken-1" @click='commentPost.likesCount-=1' v-if="commentPost.likesCount>0"><v-icon>mdi-heart</v-icon>{{commentPost.likesCount}}</v-btn>
                                    <v-btn icon color="red darken-1" @click='commentPost.likesCount+=1' v-if="commentPost.likesCount<=0"><v-icon>mdi-heart-outline</v-icon></v-btn>
                                    <v-text-field class="respondTextField" label="Respond" append-icon="mdi-send" @click:append="sendComment()"></v-text-field>
                                </div>
                            </v-card-actions>
                        </v-card>
                    </v-card>
                </div>
                <!-- Account Tab -->
                <div v-if="tab == 'tab-3'">
                    <div v-if="loggedToken == undefined">
                        <br><v-btn outlined text block large @click="isSettingsOpened = !isSettingsOpened">Login</v-btn><br>
                        <v-btn outlined text block large color="info" @click="isSettingsOpened = !isSettingsOpened">Create Account</v-btn>
                        <v-alert class="notify" type="error" transition="scale-transition">You are not logged in to an Prodigy Media, please login or create one on your settings app.</v-alert>
                    </div>
                    <div v-if="loggedToken != undefined">
                        <!-- Using the first user to debug -->
                        <v-list two-line style="background: none;">
                            <v-subheader>Your Account</v-subheader>
                            <v-list-item>
                                <v-list-item-icon>
                                    ‎<v-avatar size="35"><img :src="getAccountData[loggedToken].avatar"></v-avatar>
                                </v-list-item-icon>
                                <v-list-item-content>
                                    <v-list-item-title>{{ getAccountData[loggedToken].username }}</v-list-item-title>
                                    <v-list-item-subtitle>Your profile description</v-list-item-subtitle>
                                </v-list-item-content>
                                <v-list-item-icon>
                                    <v-btn icon><v-icon>mdi-pencil</v-icon></v-btn> <!-- Will open the settings app to change/edit the profile -->
                                </v-list-item-icon>
                            </v-list-item>

                            <v-divider inset></v-divider>
                            <v-subheader>Friends</v-subheader>

                            <v-list-item>
                                <v-list-item-icon>
                                    ‎<v-avatar size="35"><img :src="getAccountData[1].avatar"></v-avatar>
                                </v-list-item-icon>
                                <v-list-item-content>
                                    <v-list-item-title>{{ getAccountData[1].username }}</v-list-item-title>
                                    <v-list-item-subtitle>User Description</v-list-item-subtitle>
                                </v-list-item-content>
                            </v-list-item>
                            <v-list-item>
                                <v-list-item-icon>
                                    ‎<v-avatar size="35"><img :src="getAccountData[2].avatar"></v-avatar>
                                </v-list-item-icon>
                                <v-list-item-content>
                                    <v-list-item-title>{{ getAccountData[2].username }}</v-list-item-title>
                                    <v-list-item-subtitle>User Description</v-list-item-subtitle>
                                </v-list-item-content>
                            </v-list-item>

                            <v-divider inset></v-divider>
                            <v-subheader>Archived Tweets</v-subheader>
                            <div v-for="(post, id) in twitterPosts" :key="id">
                                <v-card v-if="post.archived" class="post" dark>
                                    <v-btn style="position: absolute; right: 10px; top: 6px;" icon color="grey darken-1" :disabled="!isUserAnAdmin" @click='post.sticked=false' v-if="post.sticked==true"><v-icon>mdi-pin</v-icon></v-btn>
                                    <v-card-title><v-avatar size="25"><img src="https://cdn.vuetifyjs.com/images/john.jpg"></v-avatar>‏‏‎ ‎‏‏‎ ‎{{ post.author }}</v-card-title>
                                    <v-card-subtitle>{{ post.text }}</v-card-subtitle>
                                    <v-img v-if="isUriImage" :src="post.text"></v-img>
                                    <v-card-actions>
                                        <div>
                                            <v-btn icon color="red darken-1" @click='post.likesCount-=1' v-if="post.likesCount>0"><v-icon>mdi-heart</v-icon>{{post.likesCount}}</v-btn>
                                            <v-btn icon color="red darken-1" @click='post.likesCount+=1' v-if="post.likesCount<=0"><v-icon>mdi-heart-outline</v-icon></v-btn>
                                            <v-btn icon color="info darken-1" @click='post.archived=false' v-if="post.archived==true"><v-icon>mdi-archive</v-icon></v-btn>
                                            <v-btn icon color="info darken-1" @click='post.archived=true' v-if="post.archived==false"><v-icon>mdi-archive-outline</v-icon></v-btn>
                                            <v-text-field class="commentTextField" label="Comment" append-icon="mdi-twitter" @click:append="sendComment()"></v-text-field>
                                        </div>
                                    </v-card-actions>
                                </v-card>
                            </div>
                        </v-list>
                    </div>‏‏‎
                </div>
                <!-- Global App -->
                <!--v-btn class="mainBtn" color="info" fab dark><v-icon dark>mdi-plus</v-icon></v-btn-->
            </div>
            <SettingsApp class="onTopOf" v-if="isSettingsOpened"/>
        </v-app>
    </div>
</template>

<script>
import SettingsApp from '../Settings/SettingsApp';

export default {
    name: 'TwitterApp',
    components: {
        SettingsApp
    },
    data: () => ({
        tab: null,
        isUserAnAdmin: true,
        loggedToken: undefined,
        isSettingsOpened: false,
        twitterPosts: [
            {
                id: 1,
                title: "Title goes here",
                text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin porta at diam vel pretium. Duis dui ante, facilisis eget finibus nec, tincidunt iaculis lacus. Nullam nec risus mi.",
                comments: [
                    {
                        author: "UserName",
                        comment: "https://i.redd.it/wyptzansk7m61.png",
                        likesCount: 0
                    },
                    {
                        author: "Mack",
                        comment: "@UserName You Cunt!",
                        likesCount: 0
                    },
                    {
                        author: "Disc",
                        comment: "@UserName @Mack You potato!",
                        likesCount: 0
                    }
                ],
                author: "Mack",
                likesCount: 0,
                archived: true,
                sticked: true,
                date: '25.03.1981'
            },
            {
                id: 2,
                title: "Title goes here",
                text: "Proin porta at diam vel pretium. Duis dui ante, facilisis eget finibus nec, tincidunt iaculis lacus. Nullam nec risus mi.",
                comments: [],
                author: "Mack",
                likesCount: 0,
                archived: false,
                sticked: false,
                date: '25.03.1982'
            },
            {
                id: 3,
                title: "Title goes here",
                text: "https://pbs.twimg.com/profile_images/1113159395922317312/6Q2DT5Yo.jpg",
                comments: [],
                author: "Mack",
                likesCount: 0,
                archived: false,
                sticked: false,
                date: '25.03.1983'
            }
        ]
    }),
    mounted() {
    },
    computed: {
        sortedByLikes: function (){
            return this.twitterPosts.slice().sort(function(a, b){
                return (a.likesCount < b.likesCount) ? 1 : -1;
            });
        },
        sortedByDate: function (){
            return this.twitterPosts.slice().sort(function(a, b){
                return (a.date < b.date) ? 1 : -1;
            });
        },
        getAccountData() {
            const phone = this.$store.state.accountsData;
            if (phone) {
                return phone
            }
            return '';
        }
    },
    methods: {
        isUriImage: function(uri) {
            //make sure we remove any nasty GET params 
            uri = uri.split('?')[0];
            //moving on, split the uri into parts that had dots before them
            var parts = uri.split('.');
            //get the last part ( should be the extension )
            var extension = parts[parts.length-1];
            //define some image types to test against
            var imageTypes = ['jpg','jpeg','tiff','png','gif','bmp'];
            //check if the extension matches anything in the list.
            if(imageTypes.indexOf(extension) !== -1) {
                return true;   
            }
        }
    }
}
</script>

<style lang="less" scoped>
@import '@/theme.less';

#app {
    border-top-left-radius: 32px;
    border-top-right-radius: 32px;
}

.appBar {
    width: 305px;
    max-width: 305px;
    padding-top: 20px;
}

.appContainer {
    width: 305px;
    max-width: 305px;
    height: 485px;
    max-height: 485px;
    padding-top: 7px;
    padding-left: 7px;
    padding-right: 7px;
    font-size: 17px;
    overflow-y: auto;
}

.onTopOf {
    position: absolute;
    top: 0;
}

.post {
    margin-top: 3px;
    margin-bottom: 11px;
}

.commentTextField {
    width: 68%;
    height: 40px;
    margin-left: 80px;
    margin-top: -50px;
    margin-bottom: 10px;
}

.respondTextField {
    position: absolute;
    width: 78%;
    height: 40px;
    left: 50px;
    bottom: 20px;
}

.notify {
    top: 420px;
}

</style>