<template lang="pug" style="margin-top: 0 !important; color: black;">
  #Login
    b-loading(:active.sync="isLoading" :canCancel="true")
    .mainDiv
      .box
        .columns
          .column
            b-radio(v-model="formAction", native-value="login", @input="print", style="font: bold 1vw Arial; color: black; padding: 15px 20px 0 5px;") Login &nbsp&nbsp
            b-radio(v-model="formAction", native-value="register", @input="print", style="font: bold 1vw Arial; color: black; margin-left: 50px; padding: 20px 20px 0 5px;") Register
        .columns
          .column(class="mwidth")
            b-field(style="width: 100px; height: 10px; font: bold 1vw Arial; margin: 0 20px 0 0; color: black;") User ID &nbsp
            b-input(minlength=4, v-model="userID", style="width: 200px; height: 20px; font: bold 1vw Arial; margin: 0 25px 0 0; color: black;")
        .columns(v-if="formAction=='register'")
          .column(class="mwidth")
            b-field(style="width: 100px; height: 10px; font: bold 1vw Arial; margin: 0 30px 0 5px; color: black;") User Name &nbsp
            b-input(minlength=2, v-model="userName", style="width: 200px; font: bold 1vw Arial; margin: 0 40px 0 0; color: black;")
        .columns
          .column(class="mwidth")
            b-field(style="width: 100px; height: 10px; font: bold 1vw Arial; margin: 0 30px 0 0; color: black;") Password &nbsp
            b-input(minlength=4, v-model="password", style="width: 200px; font:italic small-caps bold 100vw georgia; margin: 0 36px 0 0; color: black;")
        .columns
          .column
            .button(style="width: 200px; height: 45px; font: bold 1vw Arial; margin: 0 0 0 95px; color: black;  border: 3px solid rgb(20, 55, 140);", @click="connect") Send  
    vue-particles(style="height: 100%; width: 100%;", color="#01289f")
</template>

<script>
export default {
  name: 'Login',
  data () {
    return {
    isLoading: false,
    userID: '',
    password: '',
    userName: '',
    myBool: false,
    formAction: 'login',
    }
  },
  methods: {
    print(){
      console.log(this.formAction);
    },
    connect(){
      if ((this.userID.length > 3) && (this.password.length > 3) && (this.formAction)){
        this.isLoading = true;
        let request = {};
        this.formAction=='login' ? request["task"] = "login" : request['task'] = 'register';
        request["usersID"] = this.userID;
        request["usersPass"] = this.password;
        request["usersName"] = this.userName;
        this.axios.post('http://localhost/connect.php',request).then((response) => {
          response = response.data;
                  if(response[0]!="000")
                  {
                    console.log("connect() login failed!");
                    this.wrongeLogin();
                  }
                  else{
                    console.log("connect() successed!");
                    localStorage.setItem("currentUserID", this.userID)
                    localStorage.setItem("currentUsername", this.userName);
                    localStorage.setItem("currentPassword", this.password);
                    console.log("currentUserID", this.userID); // printed correctly
                    console.log("currentUsername", this.userName); // missing!
                    console.log("currentPassword", this.password); // printed correctly
                    this.$store.state.userLogged=response[2];
                    localStorage.setItem("storestate",response[2]);
                    // console.log("this.$store.state.userLogged:"+this.$store.state.userLogged.userID);
                    this.$router.replace('/posts');
                  }
          }).catch((err) => {console.error(err);});
          this.isLoading = false;
      }
    },
    wrongeLogin(){
        this.$toast.open({
                    duration: 5000,
                    message: `user ID, Name OR Password are WRONG! (login)`,
                    position: 'is-bottom',
                    type: 'is-danger'
                })
    },
  }
}
</script>

<style scoped>
    @import '~fullcalendar/dist/fullcalendar.css';
#Login{
    background-image: url('https://d2v9y0dukr6mq2.cloudfront.net/video/thumbnail/c7Md1Ka/facebook-icon-text-background_rrwa6plke_thumbnail-full01.png');
  /* background-image: url('https://image.freepik.com/free-vector/abstract-low-poly-design-background_1048-8196.jpg'); */
  background-repeat: no-repeat;
  background-position: right top;
  background-attachment: fixed;
  background-size: 100% 100%;
}
.mainDiv{
position: absolute;
left: 10%;
top: 20%;
}
.columns{
    margin: 10px;
    padding: 10px;
    height: 85px;
}
.box{
  min-width: 200px;
  width: 60vw;
  margin-left: auto;
  margin-right: auto;
  background: rgba(50, 103, 250, 0.178);
}
.mwidth{
width: 200px;
display: flex;
justify-content: center;
}
</style>
