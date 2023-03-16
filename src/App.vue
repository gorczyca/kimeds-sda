<script setup>
import RdfGraph from './components/RdfGraph.vue'
import Tab from './components/Tab.vue'
import Tabs from './components/Tabs.vue'
import Code from './components/Code.vue'
import Table from './components/Table.vue'
</script>


<template>
  <div>

    <header>
      <div class="logo left">
        <img src="./assets/img/kimeds_logo.png" alt="KIMedS logo" height="80px">
      </div>
      <div class="title">
        <h3>KIMEDS</h3>
        <!-- <h3>Safe Design Arguments (SDA) — Digital Safety Exchange Format</h3> -->
      </div>
      <div class="logo right">
        <img src="./assets/img/iccl_logo.png" alt="Right logo" width="200px">
      </div>
    </header>


    <Tabs class="main-tabs">
      <Tab title="Tabular view">
        <Table></Table>
      </Tab>
      <Tab title="Code">
        <Code></Code>
      </Tab>
      <Tab title="Graph">
        <RdfGraph></RdfGraph>
      </Tab>
    </Tabs>
  </div>
</template>

<script>
export default {
  name: 'App',
  components: {
    RdfGraph,
    Tab,
    Tabs,
  }
}
</script>

<style>
header {
  display: flex;
  margin: 15px;

}


.title {
  flex-grow: 2;
  text-align: center;
  font-size: 20px;
  /* font-size: 20px;
  font-weight: bold;
  text-align: center;
  margin: 0;
  position: absolute;
  left: 50%;
  transform: translateX(-50%); */
}


/* */

div.main-tabs>ul {
  text-align: center;
}

div.main-tabs>ul>li {
  padding: 8px 15px;
  background-color: lightcyan;
  margin: 0 3px;
  border-radius: 5px;
  border: 1px solid black;

}

div.main-tabs>ul>li:hover {
  background-color: white;
  /* text-decoration: underline; */
}

div.main-tabs>ul>li.tabs__selected {
  /* text-decoration: underline; */
  background-color: white;
  font-weight: bold;
  /* text-decoration-line: underline; */
  text-decoration-thickness: 3px;
}
</style>

