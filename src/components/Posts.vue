<template lang="pug">
  #posts
    //- b-loading(:active.sync="isLoading" :canCancel="true")
    .mainDiv(style="display: flex; flex-direction: column;")
      //- .button(@click="print") PRESS
      .columns
        .column
          p(@click="isNewPost=true", style="margin: 20px; font: bold 2vw Arial;") New Post &nbsp&nbsp
          i.fa.fa-plus-circle(aria-hidden='true', style="font-size: 50px; margin: 30px;", @click="isNewPost=true")          
      .columns
        .column
            b-field
              b-input(placeholder='Search Friends',@input="searchFriends",type='search')
              p.control
                button.button.is-primary Search
              b-field
                b-select(multiple='', native-size='4', v-model='selectedOptions', :style='autoHide ? `visibility: hidden;`:``')
                  option(v-for="(item, index) in autoCData", :value='item', @click="selectedFriend(item,index)") {{item}}  
      //- .columns
      //-   .column
      //-       b-autocomplete(
      //-         :data='autoCData', 
      //-         placeholder='Search Friends', 
      //-         field='title', 
      //-         :loading='isFetching', 
      //-         @input="searchFriends",
      //-          @select='print'
      //-          )
      .columns(style="display: flex; flex-direction: column;")
        .column(v-for="item in posts")
          div(style="display: flex; flex-direction: row;")
            .card(style="width: 500px; max-height: 600px;")
              .card-image(v-if='item.postsPic')
                figure.image.is-4by3
                  img( :src='item.postsPic', @click="resize(item.postsPic)", alt='Placeholder image')
                  //- img(v-if='!item.postsPic', src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBiG0La7Zm4S4DgIvtx2Oae636OpMYbS65ore8PBx93cxYEoeXwg', alt='Placeholder image')          
              .card-content
                .media
                  .media-left(v-if='item.postsPic')
                    figure.image.is-48x48
                      img( :src='item.postsPic', alt='Placeholder image')
                  .media-content
                    p.title.is-4 {{item.usersName}}
                    //- p.subtitle.is-6(@click="getPosts(item.usersID)")  @{{item.usersID}}
                .content
                  | {{item.postsContent}}
                  //- br
                  .column.is-full
                        | {{ item.postsDateCreated }}
                  .column.is-full
                    .button(@click="replyPost(item)") Replies
                    i.fa.fa-arrow-circle-o-down(v-if="replyBool.indexOf(item.postsID)", aria-hidden='true', style="font-size: 40px;", @click="activeReply('insert',item)")
                    i.fa.fa-arrow-circle-o-right(v-if="!replyBool.indexOf(item.postsID)", aria-hidden='true', style="font-size: 40px;", @click="activeReply('pull',item)")               
            .card(v-if="!replyBool.indexOf(item.postsID)", style="min-width: 300px;")
              textarea.textarea(placeholder='Reply', v-model="item.replyContent")
              .button.is-success(@click="sendReply(item)") Send Reply
                  //- .columns(style="display: flex;")                
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
                    b-field(style="margin-right: 5px;") Pic Link:
                    b-input(minlength=2, v-model="newPostsPicLink", style="width: 500px;")
                textarea.textarea(placeholder='Reply', v-model="newPostContent")
                br
                .button.is-success(@click="newPost") Send
</template>

<script>
export default {
  name: 'Login',
  data () {
    return {
      isLoading: false,
      arr: [],
      isImageModalActive: false,
      isPostActive: false,
      replyBool:[],
      posts: {},
      replies:{},
      authKey: 6,
      userID: '',
      password: '',
      userName: '',
      bigImg: '',
      myBool: false,
      formAction: 'login',

      isNewPost: false,
      newPostIsPrivate: false,
      newPostContent: '',
      newPostsPicLink: '',

      autoCData: [],
      selectedOptions: [],
      autoHide: false,
      isFetching: false,
    }
  },
  mounted: function() {
    // this.bringPosts(this.userID, this.username, this.userPassword);
    this.bringPosts(this.userID);
    console.log("From  mounted: function() at Posts.vue");
    console.log("item.usersName: "+item.usersName);
  },
  methods: {
    searchFriends(e){
      // console.log("E: " +e)
      this.autoHide = true;
      this.autoCData= [];
      if(e){
        this.isFetching = true;
        let request = {};
          request["task"] = "friendsAutoComplete";
          request["data"] = e;
        this.axios.post('http://localhost/connect.php',request).then((response) => {
          response = response.data;
          console.log("searchFriends(e)"+response);
          // console.log(response[2]);
          // if(response[2]==0 && response[2][0].length){
          //   this.autoCData = [];
          // }
          // else
          this.autoCData = response[2];
          this.autoHide = false;
                // response[2].forEach((item) => 
                // this.autoCData.push(item.usersID+ ' - ' + item.usersName)
                // )            
                // this.isFetching = false;
          }).catch((err) => {console.error(err);})
          // this.isFetching = false;
      }
    },
    selectedFriend(item, index){
        let request = {};
          request["task"] = "insertFriend";
          request["data"] = {};
          request["data"]["followedID"] = item.usersID;
          console.log("selectedFriend(item, index):item.usersID: ", item.usersID);
          request["data"]["followerID"] = this.$store.state.userLogged;
          console.log("followerID: ",request["data"]["followerID"]);
          if(item.usersID != this.$store.state.userLogged.usersID){
          this.axios.post('http://localhost/connect.php',request).then((response) => {
          response = response.data;
          console.log("userID:",this.userID);
             if(response[0]!="000"){
                    this.$toast.open({
                      duration: 5000,
                      message: `Something is Wrong! selectedFriend post.vue2 file`,
                      position: 'is-bottom',
                      type: 'is-danger'
                })
                    }
                  else{
                  this.$toast.open({
                      duration: 5000,
                      message: `Friend Added SUCCESSFULLY!`,
                      position: 'is-bottom',
                      type: 'is-success'
                  });
                  this.autoHide = true;
                  console.log("From selectedFriend -> item.usersName: " + item.usersName);
                  this.bringPosts(item.usersID);
                  }
          }).catch((err) => {console.error(err);})}
          else{
            this.$toast.open({
                      duration: 5000,
                      message: `You can't follow yourself!`,
                      position: 'is-bottom',
                      type: 'is-danger'
                  })
          }
    },
    newPost(){
      if(!this.newPostContent){
        this.$toast.open({
                        duration: 5000,
                        message: `NO CONTENT!`,
                        position: 'is-bottom',
                        type: 'is-danger'
                    })}
      else{
        let request = {};
      request["task"] = "insertPost";
      request["data"] = {};
      request["data"]["usersID"] = this.$store.state.userLogged.usersID;
      var userLoggedID = request["data"]["usersID"];
      console.log("newPost userLoggedID: " + userLoggedID);
      request["data"]["postsContent"] = this.newPostContent;
      request["data"]["postsPic"] = this.newPostsPicLink;
      request["data"]["private"] = this.newPostIsPrivate ? 1 : 0;
        this.axios.post('http://localhost/connect.php',request).then((response) => {
          response = response.data;
                  if(response[0]!="000")
                  {
                    console.log("newPost : failed!");
                    this.wrongeLogin();
                  }
                  else{
                  this.$toast.open({
                      duration: 5000,
                      message: `Post Inserted SUCCESSFULLY!`,
                      position: 'is-bottom',
                      type: 'is-success'
                  });
                 this.isNewPost=false;
                  console.log("userLoggedID:"  + userLoggedID);
                  console.log("usersName:"  + item.usersName);                 
                  this.bringPosts(userLoggedID);
                  }
          }).catch((err) => {console.error(err);})
      }
    },
    sendReply(item){
      let request = {};
      request["task"] = "insertReply";
      request["data"] = item;
      if(item.replyContent){
        this.axios.post('http://localhost/connect.php',request).then((response) => {
          response = response.data;
                  if(response[0]!="000"){
                    this.$toast.open({
                      duration: 5000,
                      message: `No Replies!`,
                      position: 'is-bottom',
                      type: 'is-danger'
                })
                    }
                  else{
                  this.$toast.open({
                      duration: 5000,
                      message: `Replied SUCCESSFULLY!`,
                      position: 'is-bottom',
                      type: 'is-success'
                  });
                  item.replyContent = '';
                  this.activeReply('eject',item);
                  }
          }).catch((err) => {console.error(err);})}
      else{
        this.$toast.open({
                        duration: 5000,
                        message: `NO CONTENT!`,
                        position: 'is-bottom',
                        type: 'is-danger'
                    })
      }  
    },
    activeReply(sender,item){
      if(sender=="insert")
      this.replyBool.push(item.postsID);
      else
       this.replyBool.splice(this.replyBool.indexOf(item.postsID),1);
    },
    print(item, i){
      console.log(item, i);
      // this.isPostActive=!this.isPostActive
    },
    resize(img){
      this.bigImg=img;
      this.isImageModalActive=!this.isImageModalActive;
    },
    bringPosts(currUID){
        //  bringPosts(currUID, currUN, currUP){ 
      var userID = localStorage.getItem("currentUserID");
      var userPassword = localStorage.getItem("currentPassword");
      var username = localStorage.getItem("currentUsername");
      console.log("bringPosts() Post.vue");
      console.log("userID:" + userID + "from sent args: " + currUID); //from localStorage is correct, but from sent arg isn't!
      console.log("userPassword:"  + userPassword);//printed correctly
      console.log("username:"  + username);//missing
      let request = {};
        request["task"] = "getPosts";
        request["data"] = this.$store.state.userLogged;
        console.log("0:post:bringPosts()request -> userLogged.usersName: " + this.$store.state.userLogged.usersName); // working!!!
        this.axios.post('http://localhost/connect.php',request).then((response) => {
          response = response.data;
                  console.log("1:post:bringPosts()response: " +response[2]);
                  // console.log("response[2]:" +response[2]);
                  if(response[0]!="000")
                  {
                    console.log("2:post:bringPosts()  post file");
                    console.log("userID:"+this.userID);
                    // console.log("response[0]:", response[0]);
                    //this.wrongeLogin();
                  }
                  else{
                    console.log("response[0]==000: ", response[2]);
                    console.log("userID:",this.userID);
                   this.posts = response[2];
                  }
          }).catch((err) => {console.error(err);})
    },
    wrongeLogin(){
        this.$toast.open({
                    duration: 5000,
                    message: `Something is WRONG! post.vue file`,
                    position: 'is-bottom',
                    type: 'is-danger'
                })
    },
     successLgin(){
        this.$toast.open({
                    duration: 5000,
                    message: this.formAction + `Successfully!`,
                    position: 'is-bottom',
                    type: 'is-success'
                })
    },
    replyPost(item){
      this.replies = {};
      console.log("item", item);
      let request = {};
        request["task"] = "getReply";
        request["postsID"] = item.postsID;
        this.axios.post('http://localhost/connect.php',request).then((response) => {
          response = response.data;
                  if(response[0]!="000")
                  {
                    console.log("replyPost(item) post file:");
                    this.wrongeLogin();
                  }
                  else{
                    console.log("reply", response[2]);
                    this.replies = response[2];
                     this.isPostActive=true;
                  }
          }).catch((err) => {console.error(err);})
    },
  }
}
</script>

<style scoped>
#posts{
  background: rgb(163, 211, 240);
  background-size: 100% 100%;
}
.mainDiv{
position: relative;
left: 0%;
top: 20%;
}
.columns{
  justify-content: right;
  align-self: right;
  margin-left: 200px;
  margin-right: auto;    
  margin-top:  200px;   
  margin-bottom:  auto;   
  padding: 80px;
  height: 50px;
  width: 50vw;

}
.box{
  min-width: 224px;
  width: 50vw;
  justify-content: right;
  align-self: right;
  margin-left: 200px;
  margin-right: auto;    
  margin-top:  200px; 
  padding: 80px;
  background: rgba(210, 224, 20, 0.788);
}
.mwidth{
width: 2000px;
display: flex;
justify-content: center;
}
.particules{
  position: fixed;
    height: 100%;
    width: 100vw;
    background: #e611b89f;
    z-index: -1;
}
.rCards{
  margin: 10px;
}
body {
margin: 20cm;
}
</style>
