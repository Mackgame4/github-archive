<template>
  <div style="display: table; margin: 0 auto;">
      <transition name="sf-fade" mode="out-in">
        <div v-if="isLogIn" key="log-in" class="modal-content">
        <SfHeading title="Login" class="aside__heading" />
          <form class="form" @submit.prevent="onLogin">
            <SfInput v-model="email" name="email" label="Email" class="form__element" type="email" />
            <SfInput v-model="password" name="password" label="Password" type="password" class="form__element" :has-show-password="true" />
            <!--SfCheckbox v-model="loginRemember" name="remember-me" label="Remember me" class="form__element form__checkbox" /-->
            <SfLoader :loading="isLoading">
              <SfButton type="submit" class="sf-button--full-width form__submit">Log In</SfButton>
            </SfLoader>
          </form>
          <SfButton class="sf-button--text action-button" @click="$router.push('/recovery')">Problemas no login?</SfButton>
          <div class="aside">
            <SfHeading title="Ainda não tens uma conta? Regista-te." class="aside__heading" />
            <SfButton class="sf-button--text" @click="isLogIn = false">Sign In</SfButton>
          </div>
        </div>
        <div v-else key="sign-up" class="modal-content">
        <SfHeading title="Register" class="aside__heading" />
          <form class="form" @submit.prevent="onRegister">
            <SfInput v-model="firstName" name="first-name" label="Nome" class="form__element" />
            <SfInput v-model="lastName" name="last-name" label="Apelido" class="form__element" />
            <SfInput v-model="email" name="email" label="Email" class="form__element" type="email" />
            <SfInput v-model="password" name="password" label="Password" type="password" class="form__element" :has-show-password="true" />
            <SfLoader :loading="isLoading">
              <SfButton type="submit" class="sf-button--full-width form__submit">Sign In</SfButton>
            </SfLoader>
          </form>
          <div class="aside">
            <SfHeading style="margin-top: 30px;" title="Já tens uma conta? Faz login." class="aside__heading" />
            <SfButton class="sf-button--text" @click="isLogIn = true">Log In</SfButton>
          </div>
        </div>
      </transition>
  </div>
</template>
<script>
import {
  mapActions
} from 'vuex';
import {
  SfInput,
  SfButton,
  SfHeading,
  SfLoader
} from "@storefront-ui/vue";
export default {
  name: "Login",
  components: {
    SfInput,
    SfButton,
    SfHeading,
    SfLoader
  },
  data() {
    return {
      isLogIn: true,
      email: "",
      password: "",
      isLoading: false,
      // Login
      loginRemember: false,
      // Sign Up
      firstName: "",
      lastName: ""
    };
  },
  watch: {
    isLogIn() {
      /*this.email = "";
      this.password = "";*/
      this.loginRemember = false;
      this.firstName = "";
      this.lastName = "";
    },
  },
  methods: {
    ...mapActions(['logout', 'loginWithEmail', 'registerByEmail', 'updateUserData']),
    onRegister() {
      this.isLoading = true
      let data = {
        email: this.email,
        password: this.password,
        displayName: this.firstName + " " + this.lastName
      }
      this.registerByEmail(data).then(() => {
        /*this.logout();
        this.isLogIn = true;
        this.$router.push('/account');
        this.$toast.warning('Please login on your account!');*/
        this.updateUserData({
          uid: this.$store.getters.currentUser.uid,
          data: {
            firstName: this.firstName,
            lastName: this.lastName,
            isAdmin: false
          }
        });
        location.reload();
      }).catch((error) => {
        this.$toast.error(error.message);
      }).then(() => {
        this.isLoading = false
      })
    },
    onLogin() {
      this.isLoading = true
      let data = {
        email: this.email,
        password: this.password
      }
      this.loginWithEmail(data).then(() => {
        this.$router.push('/store');
      }).catch((error) => {
        this.$toast.error(error.message);
      }).then(() => {
        this.isLoading = false
      })
    }
  },
};
</script>
<style lang="scss" scoped>
@import "~@storefront-ui/vue/styles";
.modal-content,
.aside__heading {
  margin-top: 20px;
}
.aside {
  display: flex;
  flex-direction: column;
  align-items: center;
}
.form {
  width: 100%;
  &__element {
    margin: var(--spacer-base) 0;
  }
  &__checkbox {
    margin: var(--spacer-xl) 0 var(--spacer-2xl) 0;
  }
  &__submit {
    margin: var(--spacer-xl) 0 0 0;
  }
}
.action-button {
  margin: var(--spacer-xl) 0;
}
.open-button {
  margin: 0 auto;
}
.aside {
  margin: 0 0 var(--spacer-xl) 0;
  &__heading {
    --heading-title-color: var(--c-primary);
    --heading-title-font-size: var(--h3-font-size);
    --heading-title-font-weight: var(--font-weight--semibold);
    margin: 0 0 var(--spacer-sm) 0;
  }
}
</style>