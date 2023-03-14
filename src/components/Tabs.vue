<template>
    <div>
        <ul class="tabs__header">
            <li v-for="(tab, index) in tabs" :key="tab.title" @click="selectTab(index)"
                :class='{ "tabs__selected": (index == selectedIndex) }'>
                {{ tab.title }}
            </li>
        </ul>
        <slot></slot>
    </div>
</template>

<script>
export default {
    data() {
        return {
            selectedIndex: 0, // the index of the selected tab,
            tabs: [],        // all of the tabs
        }
    },
    created() {
    },
    mounted() {
        this.selectTab(0)
    },
    methods: {
        selectTab(i) {
            this.selectedIndex = i
            // loop over all the tabs
            this.tabs.forEach((tab, index) => {
                if (index === i) {
                    tab.isActive = true
                    // tab.alertSelected()
                } else {
                    tab.isActive = false
                }
            })
        }
    }
}
</script>


<style>
ul.tabs__header {
    display: block;
    list-style: none;
}

ul.tabs__header>li {
    display: inline-block;
    /* margin-right: 5px; */
    cursor: pointer;
}

</style>