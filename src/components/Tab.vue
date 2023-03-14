<template>
    <div v-if="isActive">
        <slot></slot>
    </div>
</template>
  
<script>
export default {
    props: {
        title: {
            type: String,
            default: 'Tab'
        }
    },
    data() {
        return {
            isActive: true
        }
    },
    created() {
        this.$parent.tabs.push(this)
    },
    methods: {

    }
}
</script>
