<template lang="pug">
  #posts
    //- b-loading(:active.sync="isLoading" :canCancel="true")
    .mainDiv(style="display: flex; flex-direction: column;")
      //- .button(@click="print") PRESS
      .columns
        .column
          p(@click="isNewPost=true") New Post &nbsp&nbsp
          i.fa.fa-plus-circle(aria-hidden='true', style="font-size: 39px;", @click="isNewPost=true")          
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
            .card(style="min-width: 300px;")
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
                    p.subtitle.is-6(@click="getPosts(item.usersID)")  @{{item.usersID}}
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
    //- vue-particles.particules(color="#FFF"
      :particleOpacity="0.8"
      :particlesNumber="80"
      shapeType="circle"
      :particleSize="8"
      linesColor="#dedede"
      :linesWidth="1"
      :lineLinked="true"
      :lineOpacity="0.8"
      :linesDistance="150"
      :moveSpeed="3"
      :hoverEffect="true"
      hoverMode="grab"
      :clickEffect="true"
      clickMode="push")
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
    this.bringPosts();
  },
  methods: {
    searchFriends(e){
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
          console.log("selectedFriend(item, index):item.usersID", item.usersID);
          request["data"]["followerID"] = this.$store.state.userLogged;
          console.log("req",request);
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
                  this.bringPosts();
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
      request["data"]["postsContent"] = this.newPostContent;
      request["data"]["postsPic"] = this.newPostsPicLink;
      request["data"]["private"] = this.newPostIsPrivate ? 1 : 0;
        this.axios.post('http://localhost/connect.php',request).then((response) => {
          response = response.data;
                  if(response[0]!="000")
                  {
                    console.log("newPost : post file");
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
                  this.bringPosts();
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
    bringPosts(){
      let request = {};
        request["task"] = "getPosts";
        request["data"] = this.$store.state.userLogged;
        console.log("0:post:bringPosts()request: " + this.$store.state.userLogged);
        this.axios.post('http://localhost/connect.php',request).then((response) => {
          response = response.data;
                  console.log("1:post:bringPosts()response: " +response[2]);
                  if(response[0]!="000")
                  {
                    console.log("2:post:bringPosts()  post file");
                    console.log("userID:"+this.userID);
                    console.log("response[0]:", response[0]);
                    this.wrongeLogin();
                  }
                  else{
                    console.log("response[0]==000: avia: postsAns", response[2]);
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
  background: rgb(5, 243, 17);
  background-size: 50% 50%;
}
.mainDiv{
position: absolute;
left: 0%;
top: 20%;
}
.columns{
    margin: 0;
    padding: 0;
    height: 60px;
}
.box{
  min-width: 224px;
  width: 50vw;
  margin-left: auto;
  margin-right: auto;
  background: rgba(20, 224, 20, 0.788);
}
.mwidth{
width: 200px;
display: flex;
justify-content: center;
}
.particules{
  position: fixed;
    height: 100%;
    width: 100vw;
    background: #11e62e9f;
    z-index: -1;
}
.rCards{
  margin: 10px;
}
body {
margin: 20cm;
}
</style>
