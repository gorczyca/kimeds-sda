<template>
  <ul :class="isTop">
    <li v-for="node in nodes" :key="node.id" :class="[node.type, node.top ? 'top' : '']">
      <span class="sda-name">{{ node.name }}</span>
      <p v-if="node.description"> {{ node.description }} </p>
      <TreeView v-if="node.children" :nodes="node.children"></TreeView>
    </li>
  </ul>
</template>

<script>
export default {
  name: "TreeView",
  props: {
    nodes: {
      type: Array,
      default: () => [],
    },
  },
  methods: {},
  computed: {
    isTop: function() {
      if( this.nodes.every((n) => n.top)) return 'top' 
      return ''
    }

  }
};
</script>

<style scoped>
li:not(.top) {
  border: 1px solid black;
}

li {
  list-style-type: none;
  position: relative;
  border-collapse: collapse;
  padding: 5px;
}

li::before {
  position: absolute;
  left: -0.1em;
  /* Adjust this value so that it appears where you want. */
  font-size: 1em;
  /* Adjust this value so that it appears what size you want. */
}

/* li.implementationManifest::before {
  content: '🄸';
} */
li.riskSda {
  /* background-color: #e8e8fb; */
}

li.assuranceSda {
  /* background-color: #fbfbe8; */
}

li.implementationManifest {
  background-color: lightgray;
  /* background-color: #e8fbe8; */
}

li.riskSda>span.sda-name::after {
  content: " (Risk SDA)";
  font-weight: 400;
}

li.assuranceSda>span.sda-name::after {
  content: " (Assurance SDA)";
  font-weight: 400;
}

/* li.riskSda::before {
  content: '🅁';
}
li.assuranceSda::before {
  content: '🄰';
} */
ul:not(.top) {
  margin-left: 20px;
}

.sda-name {
  font-weight: bold;
  /* text-decoration: underline; */
}</style>
