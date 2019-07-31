<template lang="pug">
  #posts
    .mainDiv(style="display: flex; flex-direction: column;")
      .columns
        .column
          <a class="button is-primary" @click="isNewPost=true">Click Here For add a New Post</a>
          <a class="button is-primary" @click="isNewDetails=true">Click Here For update your details</a>
      .columns
        .column
            b-field
              b-input(placeholder='Search Friends',@input="searchFriends",type='search')
              p.control
                button.button.is-primary Search
              b-field
                b-select(multiple='', native-size='4', v-model='selectedOptions', :style='autoHide ? `visibility: hidden;`:``')
                  option(v-for="(item, index) in autoCData", :value='item', @click="selectedFriend(item,index)") {{item}}  
 
      .columns(style="display: flex; flex-direction: column;")
        .column(v-for="item in details")
          div(style="display: flex; flex-direction: row;")
            .card(style="min-width: 300px;")
              .card-image(v-if='item.detailsPic')
                figure.image.is-4by3
                  img( :src='item.detailsPic', @click="resize(item.detailsPic)", alt='Placeholder image')
              .card-content
                .media
                  .media-left(v-if='item.detailsPic')
                    figure.image.is-48x48
                      img( :src='item.detailsPic', alt='Placeholder image')
                  .media-content
                    p.title.is-4 City: {{item.userCity}} 
                    p.title.is-4 Age: {{item.userAge}}
                    p.title.is-4 About: 
                .content
                  | {{item.detailsContent}}
                  br
       



      .columns(style="display: flex; flex-direction: column;")
        .column(v-for="item in posts")
          div(style="display: flex; flex-direction: row;")
            .card(style="min-width: 300px;")
              .card-image(v-if='item.postsPic')
                figure.image.is-4by3
                  img( :src='item.postsPic', @click="resize(item.postsPic)", alt='Placeholder image')
              .card-content
                .media
                  .media-left(v-if='item.postsPic')
                    figure.image.is-48x48
                      img( :src='item.postsPic', @click="resize(item.postsPic)", alt='Placeholder image')
                  .media-left(v-if='item.postsPic2')
                    figure.image.is-48x48
                      img( :src='item.postsPic2',@click="resize(item.postsPic2)", alt='Placeholder image')
                  .media-left(v-if='item.postsPic3')
                    figure.image.is-48x48
                      img( :src='item.postsPic3',@click="resize(item.postsPic3)", alt='Placeholder image')
                  .media-left(v-if='item.postsPic4')
                    figure.image.is-48x48
                      img( :src='item.postsPic4',@click="resize(item.postsPic4)", alt='Placeholder image')
                  .media-left(v-if='item.postsPic5')
                    figure.image.is-48x48
                      img( :src='item.postsPic5',@click="resize(item.postsPic5)", alt='Placeholder image')
                  .media-left(v-if='item.postsPic6')
                    figure.image.is-48x48
                      img( :src='item.postsPic6', @click="resize(item.postsPic6)", alt='Placeholder image')
                  .media-left(v-if='item.postsPerPic')
                    figure.image.is-48x48
                      img( :src='item.postsPerPic', alt='Placeholder image')
                  .media-content
                    p.title.is-4 {{item.usersName}}
                    p.subtitle.is-6(@click="getPosts(item.usersID)")  User id: {{item.usersID}}
                .content
                  | {{item.postsContent}}
                  br
                  .column.is-full
                        | {{ item.postsDateCreated }}
                  .column.is-full
                    .button(@click="replyPost(item)") Replies
                    i.fa.fa-arrow-circle-o-down(v-if="replyBool.indexOf(item.postsID)", aria-hidden='true', style="font-size: 39px;", @click="activeReply('insert',item)")
                    i.fa.fa-arrow-circle-o-right(v-if="!replyBool.indexOf(item.postsID)", aria-hidden='true', style="font-size: 39px;", @click="activeReply('pull',item)")
                    
            .card(v-if="!replyBool.indexOf(item.postsID)", style="min-width: 300px;")
              textarea.textarea(placeholder='Reply', v-model="item.replyContent")
              .button.is-success(@click="sendReply(item)") Send Reply
      
                  
    b-modal(:active.sync='isImageModalActive')
      p.image.is-4by3
        img(:src="bigImg")
    //- Replies Modal
    b-modal(:active.sync='isPostActive')
      .card.rCards(v-for="item in replies", :style="$store.state.userLogged.usersID==item.usersID ?  `background: aquamarine;` : ''")
        .card-content
          .media
            .media-content
              p.title.is-4 {{item.usersName}}
              p.subtitle.is-6 @{{item.usersID}}
          .content
            | {{item.replyContent}}
            br
            | Date Created: {{ $moment(item.replyCreated).format('DD-MM-YYYY HH:mm') }}
    

    //- new details modal
    b-modal(:active.sync='isNewDetails')
            .card.rCards
            .card-header
              b-field(style="font-size: 40px; margin-left: 5px;") New Details 
            .card-content(style="align-items: left; display: flex; flex-direction: column;")

                .columns
                  .column                     
                  .media-content(style="display: flex; flex-direction: row;")
                    b-field(style="margin-right: 5px;") Pic Link:
                    b-input(minlength=2, v-model="newDetailsPicLink", style="width: 500px;")
                br
                .columns
                  .column
                  .media-content(style="display: flex; flex-direction: row;")
                    b-field(style="margin-right: 5px;") City:
                    b-input(minlength=2, v-model="newUserCity", style="width: 500px;")
                br
                .columns
                  .column
                  .media-content(style="display: flex; flex-direction: row;")
                    b-field(style="margin-right: 5px;") Age:
                    b-input(minlength=2, v-model="newUserAge", style="width: 500px;")
                br
                textarea.textarea(placeholder='About..', v-model="newDetailsContent") 
                br
                .button.is-success(@click="newDetails") Send
    
    
    //- new post modal
    b-modal(:active.sync='isNewPost')
          .card.rCards
            .card-header
              b-field(style="font-size: 40px; margin-left: 5px;") New Post 
            .card-content(style="align-items: left; display: flex; flex-direction: column;")
                .columns
                  .column
                    b-checkbox(v-model='newPostIsPrivate') Private     
                .columns
                  .column                     
                  .media-content(style="display: flex; flex-direction: row;")
                    b-field(style="margin-right: 5px;") Pic Link 1:
                    b-input(minlength=2, v-model="newPostsPicLink", style="width: 500px;")
                .columns
                  .column
                  .media-content(style="display: flex; flex-direction: row;")
                    b-field(style="margin-right: 5px;") Pic Link 2:
                    b-input(minlength=2, v-model="newPostsPicLink2", style="width: 500px;")
                .columns
                  .column
                  .media-content(style="display: flex; flex-direction: row;")
                    b-field(style="margin-right: 5px;") Pic Link 3:
                    b-input(minlength=2, v-model="newPostsPicLink3", style="width: 500px;")
                .columns
                  .column
                  .media-content(style="display: flex; flex-direction: row;")
                    b-field(style="margin-right: 5px;") Pic Link 4:
                    b-input(minlength=2, v-model="newPostsPicLink4", style="width: 500px;")
                .columns
                  .column
                  .media-content(style="display: flex; flex-direction: row;")
                    b-field(style="margin-right: 5px;") Pic Link 5:
                    b-input(minlength=2, v-model="newPostsPicLink5", style="width: 500px;")
                .columns
                  .column
                  .media-content(style="display: flex; flex-direction: row;")
                    b-field(style="margin-right: 5px;") Pic Link 6:
                    b-input(minlength=2, v-model="newPostsPicLink6", style="width: 500px;")
                textarea.textarea(placeholder='Reply', v-model="newPostContent")
                br
                .button.is-success(@click="newPost") Send

</template>

<script>
export default {
  name: "Login",
  data() {
    return {
      isLoading: false,
      arr: [],
      isImageModalActive: false,
      isPostActive: false,
      replyBool: [],
      posts: {},
      details: {},
      replies: {},
      authKey: 6,
      userID: "",
      userName: "",
      password: "",
      userName: "",
      bigImg: "",
      myBool: false,
      formAction: "login",

      isNewPost: false,
      isZero: true,
      cerrNum: 0,
      isNewDetails: false,
      newPostIsPrivate: false,
      newPostContent: "",
      newDetailsContent: "",
      newPostsPicLink: "",
      newPostsPicLink2: "",
      newPostsPicLink3: "",
      newPostsPicLink4: "",
      newPostsPicLink5: "",
      newPostsPicLink6: "",
      newDetailsPicLink: "",
      newUserAge: "",
      newUserCity: "",

      autoCData: [],
      selectedOptions: [],
      autoHide: false,
      isFetching: false
    };
  },
  mounted: function() {
    this.bringPosts();
    console.log("From  mounted: function() bringPosts");
    this.bringDetails();
    console.log("From  mounted: function()bringDetail");
  },
  methods: {
    searchFriends(e) {
      console.log("E: " + e);
      this.autoHide = true;
      this.autoCData = [];
      if (e) {
        this.isFetching = true;
        let request = {};
        request["task"] = "friendsAutoComplete";
        request["data"] = e;
        this.axios
          .post("http://localhost/connect.php", request)
          .then(response => {
            response = response.data;
            console.log("searchFriends(e)" + response);

            console.log(response[2]);
            if (response[2] == 0 && response[2][0].length) {
              this.autoCData = [];
            } else {
              this.autoCData = response[2];
            }
            this.autoHide = false;
            // response[2].forEach(item =>
            //   this.autoCData.push(item.usersID + " - " + item.usersName)
            // );
            // this.isFetching = false;
          })
          .catch(err => {
            console.error(err);
          });
        // this.isFetching = false;
      }
    },
    selectedFriend(item, index) {
      let request = {};
      request["task"] = "insertFriend";
      request["data"] = {};
      request["data"]["followedID"] = item.usersID;
      console.log("selectedFriend(item, index):item.usersID", item.usersID);
      request["data"]["followerID"] = this.$store.state.userLogged;
      console.log("req", request);
      if (item.usersID != this.$store.state.userLogged.usersID) {
        this.axios
          .post("http://localhost/connect.php", request)
          .then(response => {
            response = response.data;
            console.log("userID:", this.userID);
            if (response[0] != "000") {
              this.$toast.open({
                duration: 5000,
                message: `Something is Wrong! selectedFriend post.vue2 file`,
                position: "is-bottom",
                type: "is-danger"
              });
            } else {
              this.$toast.open({
                duration: 5000,
                message: `Friend Added SUCCESSFULLY!`,
                position: "is-bottom",
                type: "is-success"
              });
              this.autoHide = true;
              console.log("From  selectedFriend line 200");
              this.bringPosts();
            }
          })
          .catch(err => {
            console.error(err);
          });
      } else {
        this.$toast.open({
          duration: 5000,
          message: `You can't follow yourself!`,
          position: "is-bottom",
          type: "is-danger"
        });
      }
    },
    newPost() {
      if (!this.newPostContent) {
        this.$toast.open({
          duration: 5000,
          message: `NO CONTENT!`,
          position: "is-bottom",
          type: "is-danger"
        });
      } else {
        let request = {};
        request["task"] = "insertPost";
        request["data"] = {};
        request["data"]["usersID"] = this.$store.state.userLogged.usersID;
        request["data"]["postsContent"] = this.newPostContent;
        request["data"]["postsPic"] = this.newPostsPicLink;
        request["data"]["postsPic2"] = this.newPostsPicLink2;
        request["data"]["postsPic3"] = this.newPostsPicLink3;
        request["data"]["postsPic4"] = this.newPostsPicLink4;
        request["data"]["postsPic5"] = this.newPostsPicLink5;
        request["data"]["postsPic6"] = this.newPostsPicLink6;
        request["data"]["private"] = this.newPostIsPrivate ? 1 : 0;
        this.axios
          .post("http://localhost/connect.php", request)
          .then(response => {
            response = response.data;
            if (response[0] != "000") {
              console.log("newPost : post file");
              this.wrongeLogin();
            } else {
              this.$toast.open({
                duration: 5000,
                message: `Post Inserted SUCCESSFULLY!`,
                position: "is-bottom",
                type: "is-success"
              });
              this.isNewPost = false;
              this.bringPosts();
            }
          })
          .catch(err => {
            console.error(err);
          });
      }
    },
    newDetails() {
      if (!this.newDetailsContent) {
        this.$toast.open({
          duration: 5000,
          message: `NO DETAILS CONTENT!`,
          position: "is-bottom",
          type: "is-danger"
        });
      } else {
        console.log("usersID:" + this.$store.state.userLogged.usersID);
        console.log("this.newDetailsContent:" + this.newDetailsContent);
        console.log("this.detailsPic:" + this.detailsPic);
        console.log("this.userAge:" + this.userAge);
        console.log("this.userCity:" + this.userCity);
        let request = {};
        request["task"] = "insertDetails";
        request["data"] = {};
        request["data"]["usersID"] = this.$store.state.userLogged.usersID;
        request["data"]["detailsContent"] = this.newDetailsContent;
        request["data"]["detailsPic"] = this.newDetailsPicLink;
        request["data"]["userAge"] = this.newUserAge;
        request["data"]["userCity"] = this.newUserCity;
        //request["data"]["private"] = this.newPostIsPrivate ? 1 : 0;
        this.axios
          .post("http://localhost/connect.php", request)
          .then(response => {
            response = response.data;
            if (response[0] != "000") {
              console.log("newDetails: this.wrongeLogin();");
              this.wrongeLogin();
            } else {
              this.$toast.open({
                duration: 5000,
                message: `newDetails Inserted SUCCESSFULLY!`,
                position: "is-bottom",
                type: "is-success"
              });
              this.isNewDetails = false;

              this.bringDetails();
              this.bringPosts();
            }
          })
          .catch(err => {
            console.error(err);
          });
      }
    },
    sendReply(item) {
      let request = {};
      request["task"] = "insertReply";
      request["data"] = item;
      if (item.replyContent) {
        this.axios
          .post("http://localhost/connect.php", request)
          .then(response => {
            response = response.data;
            if (response[0] != "000") {
              this.$toast.open({
                duration: 5000,
                message: `No Replies!`,
                position: "is-bottom",
                type: "is-danger"
              });
            } else {
              this.$toast.open({
                duration: 5000,
                message: `Replied SUCCESSFULLY!`,
                position: "is-bottom",
                type: "is-success"
              });
              item.replyContent = "";
              this.activeReply("eject", item);
            }
          })
          .catch(err => {
            console.error(err);
          });
      } else {
        this.$toast.open({
          duration: 5000,
          message: `NO CONTENT!`,
          position: "is-bottom",
          type: "is-danger"
        });
      }
    },
    activeReply(sender, item) {
      if (sender == "insert") this.replyBool.push(item.postsID);
      else this.replyBool.splice(this.replyBool.indexOf(item.postsID), 1);
    },
    print(item, i) {
      console.log(item, i);
      // this.isPostActive=!this.isPostActive
    },
    resize(img) {
      this.bigImg = img;
      this.isImageModalActive = !this.isImageModalActive;
    },
    bringPosts() {
      var userID = localStorage.getItem("currentUserID");
      var userPassword = localStorage.getItem("currentPassword");
      var username = localStorage.getItem("currentUsername");
      console.log("userID:" + userID);
      console.log("userPassword:" + userPassword);
      console.log("username:" + username);

      let request = {};
      request["task"] = "getPosts";
      request["data"] = this.$store.state.userLogged;
      console.log(
        "0:post:bringPosts()request: " +
          this.$store.state.userLogged +
          " ----\n" +
          request["data"]
      );
      this.axios
        .post("http://localhost/connect.php", request)
        .then(response => {
          response = response.data;
          console.log("1:post:bringPosts()response: " + response[2]);
          console.log("response[2]:" + response[2]);
          if (response[0] != "000") {
            console.log("2:post:bringPosts()  post file");
            console.log("userID:" + this.userID);
            console.log("response[0]:", response[0]);
            //this.wrongeLogin();
          } else {
            console.log("response[0]==000: avia: postsAns", response[2]);
            console.log("userID:", this.userID);
            this.posts = response[2];
          }
        })
        .catch(err => {
          console.error(err);
        });
    },
    bringDetails() {
      var userID = localStorage.getItem("currentUserID");
      var userPassword = localStorage.getItem("currentPassword");
      var username = localStorage.getItem("currentUsername");
      console.log("userID:" + userID);
      console.log("userPassword:" + userPassword);
      console.log("username:" + username);

      let request = {};
      request["task"] = "getDetails";
      request["data"] = this.$store.state.userLogged;
      console.log(
        "0:Details:bringDetails()request: " +
          this.$store.state.userLogged +
          " ----\n" +
          request["data"]
      );
      this.axios
        .post("http://localhost/connect.php", request)
        .then(response => {
          response = response.data;
          console.log("1:getDetails()response: " + response[2]);
          console.log("response[2]:" + response[2]);
          if (response[0] != "000") {
            console.log("2:getDetails:getDetails()  wrong");
            console.log("getDetailsuserID:" + this.$store.state.userLogged);
            console.log("getDetailsresponse[0]:", response[0]);
            this.wrongeLogin();
          } else {
            console.log("getDetails success!!!response[0]:", response[0]);
            console.log("userID:", this.userID);
            this.details = response[2];
          }
        })
        .catch(err => {
          console.error(err);
        });
    },
    wrongeLogin() {
      this.$toast.open({
        duration: 5000,
        message: `Something is WRONG! post.vue file`,
        position: "is-bottom",
        type: "is-danger"
      });
    },
    successLgin() {
      this.$toast.open({
        duration: 5000,
        message: this.formAction + `Successfully!`,
        position: "is-bottom",
        type: "is-success"
      });
    },
    replyPost(item) {
      this.replies = {};
      console.log("item", item);
      let request = {};
      request["task"] = "getReply";
      request["postsID"] = item.postsID;
      this.axios
        .post("http://localhost/connect.php", request)
        .then(response => {
          response = response.data;
          if (response[0] != "000") {
            console.log("replyPost(item) post file:");
            this.wrongeLogin();
          } else {
            console.log("reply", response[2]);
            this.replies = response[2];
            this.isPostActive = true;
          }
        })
        .catch(err => {
          console.error(err);
        });
    }
  }
};
</script>

<style scoped>
#posts {
  background: rgb(163, 211, 240);
  background-size: 20% 20%;
}
.mainDiv {
  position: relative;
  left: 0%;
  top: 20%;
}
.columns {
  justify-content: right;
  margin: 0;
  padding: 0;
  height: 60;
}
.box {
  width: 50vw;
  margin-left: auto;
  margin-right: auto;
  padding: 20;
  background: rgba(210, 224, 20, 0.788);
}
.mwidth {
  width: 2000px;
  display: flex;
  justify-content: center;
}
.particules {
  position: fixed;
  height: 100%;
  width: 100vw;
  background: #e611b89f;
  z-index: -1;
}
.rCards {
  margin: 10px 5px;
}
#app2 {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #e21a5d;
  margin-top: 60px;
}
</style>

