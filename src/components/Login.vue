<template lang="pug" style="margin-top: 0 !important">
  #Login
    b-loading(:active.sync="isLoading" :canCancel="true")
    .mainDiv
      .box
        .columns
          .column
            b-radio(v-model="formAction", native-value="login", @input="print" style="font: bold 140% Arial;") Login &nbsp&nbsp
            b-radio(v-model="formAction", native-value="register", @input="print" style="font: bold 140% Arial;") Register
        .columns
          .column(class="mwidth")
            b-field(style="width: 100px; height: 30px; padding: 5px; font: bold 140% Arial;") UserID: &nbsp
            b-input(minlength=4, v-model="userID", style="width: 70%; height: 20px; font: bold 140% Arial;")
        .columns(v-if="formAction=='register'")
          .column(class="mwidth")
            b-field(style="width: 150px; height: 30px; font: bold 140% Arial;") User Name: &nbsp
            b-input(minlength=2, v-model="userName", style="width: 70%;")
        .columns
          .column(class="mwidth")
            b-field(style="width: 100px; height: 20px; margin: 20px 0 20px 0; padding: 1px;  font: bold 140% Arial;") Password &nbsp
            b-input(minlength=4, v-model="password", style="width: 70%;")
        .columns
          .column
            .button(style="width: 200px; height: 40px; padding: 0 5px 0 5px; font: bold 140% Arial;", @click="connect") Send  
    vue-particles(style="height: 110vh; width:0", color="FFF#")
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
  name: "Login",
  data() {
    return {
      isLoading: false,
      userID: "",
      password: "",
      userName: "",
      myBool: false,
      formAction: "login"
    };
  },
  methods: {
    print() {
      console.log(this.formAction);
    },
    connect() {
      if (
        this.userID.length > 3 &&
        this.password.length > 3 &&
        this.formAction
      ) {
        this.isLoading = true;
        let request = {};
        this.formAction == "login"
          ? (request["task"] = "login")
          : (request["task"] = "register");
        request["usersID"] = this.userID;
        request["usersPass"] = this.password;
        request["usersName"] = this.userName;
        this.axios
          .post("http://localhost/connect.php", request)
          .then(response => {
            response = response.data;
            if (response[0] != "000") {
              console.log("connect() login file");
              this.wrongeLogin();
            } else {
              console.log("CONNNECT SUCCESSFULY!");
              localStorage.setItem("currentUserID", this.userID);
              localStorage.setItem("currentUsername", this.userName);
              localStorage.setItem("currentPassword", this.password);

              this.$store.state.userLogged = response[2];
              localStorage.setItem("storestate", response[2]);
              console.log(
                "this.$store.state.userLogged:" +
                  this.$store.state.userLogged.userID
              );
              this.$router.replace("/posts");
            }
          })
          .catch(err => {
            console.error(err);
          });
        this.isLoading = false;
      }
    },
    wrongeLogin() {
      this.$toast.open({
        duration: 5000,
        message: `user ID, Name OR Password are WRONG! (login)`,
        position: "is-bottom",
        type: "is-danger"
      });
    }
  }
};
</script>

<style scoped>
@import "~fullcalendar/dist/fullcalendar.css";
#Login {
  color: black; 
  background-image: url("https://d2v9y0dukr6mq2.cloudfront.net/video/thumbnail/c7Md1Ka/facebook-icon-text-background_rrwa6plke_thumbnail-full01.png");
  /* background-image: url('https://image.freepik.com/free-vector/abstract-low-poly-design-background_1048-8196.jpg'); */
  background-repeat: no-repeat;
  background-position: right top;
  /* background-attachment: fixed; */
  background-size: 100% 100%;
}
.mainDiv {
  color: black;
  position: fixed;
  left: 5%;
  top: 20%;
}
.columns {
  color: black;
  margin: 10;
  padding: 10;
  height: 100px;
  width: 80vw;

}
.box {
  font: bold 120% Arial;
  width: 100%;
  background: rgba(50, 103, 250, 0.178);
}
.mwidth {
  width: 60vw;
  font: bold 120px;;
  /* width: 200px; */
  /* display: flex; */
  justify-content: center;
}
b-radio{
  font: bold 120px;
}
</style>
