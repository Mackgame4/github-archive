<template>
  <div style="display: table; margin: 17px auto;">
    <SfHeading title="Recuperar Password" class="aside__heading" />
    <form class="form" @submit.prevent="onPasswordRecovery">
      <SfInput v-model="email" name="email" label="Email" class="form__element" type="email" />
      <SfLoader :loading="isLoading">
        <SfButton type="submit" class="sf-button--full-width">Enviar</SfButton>
      </SfLoader>
      <div v-if="isLoading" style="margin-bottom: 50px;"></div>
      <div class="aside">
        <SfHeading style="margin-top: 17px;" title="Já tens uma conta? Faz login." class="aside__heading" />
        <SfButton class="sf-button--text" @click="$router.push('/account')">Log In</SfButton>
      </div>
    </form>
  </div>
</template>

<script>
import { SfInput, SfButton, SfHeading, SfLoader } from "@storefront-ui/vue";
import { mapActions } from 'vuex';
export default {
  components: {
    SfInput,
    SfButton,
    SfHeading,
    SfLoader
  },
  data() {
    return {
      email: '',
      isLoading: false
    }
  },
  methods: {
    ...mapActions(['recoverPassword']),
    onPasswordRecovery() {
      this.isLoading = true
      let data = {
        email: this.email
      }
      this.recoverPassword(data).then(() => {
        this.$router.push('/');
      })
        .catch((error) => {
          this.$toast.error(error.message);
        }).then(() => {
          this.isLoading = false
        })
    }
  }
}
</script>

<style lang="scss" scoped>
@import "~@storefront-ui/vue/styles";
.modal-content,
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