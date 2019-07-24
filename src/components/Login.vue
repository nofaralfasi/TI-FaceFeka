<template lang="pug" style="margin-top: 0 !important">
  #Login
    b-loading(:active.sync="isLoading" :canCancel="true")
    .mainDiv
      .box
        .columns
          .column
            b-radio(v-model="formAction", native-value="login", @input="print") Login &nbsp&nbsp
            b-radio(v-model="formAction", native-value="register", @input="print") Register
        .columns
          .column(class="mwidth")
            b-field(style="width: 90px;") UserID &nbsp
            b-input(minlength=4, v-model="userID", style="width: 200px;")
        .columns(v-if="formAction=='register'")
          .column(class="mwidth")
            b-field(style="width: 90px;") User Name &nbsp
            b-input(minlength=2, v-model="userName", style="width: 200px;")
        .columns
          .column(class="mwidth")
            b-field(style="width: 90px;") Password &nbsp
            b-input(minlength=4, v-model="password", style="width: 200px;")
        .columns
          .column
            .button(style="width: 100px;", @click="connect") Send
    vue-particles(style="height: 200vh; width: 100vw;", color="#FFF")
      //- :particleOpacity="0.8"
      //- :particlesNumber="80"
      //- shapeType="circle"
      //- :particleSize="8"
      //- linesColor="#dedede"
      //- :linesWidth="1"
      //- :lineLinked="true"
      //- :lineOpacity="0.8"
      //- :linesDistance="150"
      //- :moveSpeed="0"
      //- :hoverEffect="true"
      //- hoverMode="grab"
      //- :clickEffect="true"
      //- clickMode="push")
 
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
                    console.log("connect() login file");
                    this.wrongeLogin();
                  }
                  else{
                    localStorage.setItem("currentUserID", this.userID)
                    localStorage.setItem("currentUsername", this.userName);
                    localStorage.setItem("currentPassword", this.password)
                    this.$store.state.userLogged=response[2];
                    console.log(this.$store.state.userLogged.userID);
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

    /* @import '~fullcalendar/dist/fullcalendar.css'; */

#Login{
  background-image: url('https://image.freepik.com/free-vector/abstract-low-poly-design-background_1048-8196.jpg'); 
  /* background: #59f9d1; */
  background-size: 100% 100%;
}
.mainDiv{
position: absolute;
left: 28%;
top: 20%;
}
.columns{
    margin: 0;
    padding: 0;
    height: 60px;
}
.box{
  min-width: 324px;
  width: 50vw;
  margin-left: auto;
  margin-right: auto;
  background: rgba(219, 20, 153, 0.123);
}
.mwidth{
width: 200px;
display: flex;
justify-content: center;
}
</style>
