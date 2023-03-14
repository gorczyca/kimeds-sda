<script setup>
import GenericTableCell from '/src/components/GenericTableCell.vue'
import RiskTableCell from '/src/components/RiskTableCell.vue'
import TreeView from '/src/components/TreeView.vue'
</script>


<template>
    <table class="table-bordered">
        <thead class="thead-light">

            <tr>
                <!-- <th>Function</th>
                    <th>Hazard</th>
                    <th>Hazardous situation</th>
                    <th>Device component</th> -->
                <th>Device specific hazard</th>
                <th >Risk</th>
                <th >Mitigation</th>
                <!-- <th>Residual risk</th> -->
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <GenericTableCell :data="sda.function" :title="'Function'"></GenericTableCell>
                    <GenericTableCell :data="sda.hazard" :title="'Hazard'"></GenericTableCell>
                    <GenericTableCell :data="sda.hazardousSituation" :title="'Hazardous situation'"></GenericTableCell>
                    <GenericTableCell :data="sda.deviceComponent" :title="'Device component'"></GenericTableCell>
                </td>
                <RiskTableCell :risk="sda.risk"></RiskTableCell>
                <TreeView :nodes="sda.mitigation"></TreeView>
                <!-- <RiskTableCell :risk="sda.residualRisk"></RiskTableCell> -->
            </tr>
        </tbody>
    </table>
</template>

<script>
import sdaJson from '/src/assets/sda.json'

export default {
    computed: {
        sda: function () {
            return sdaJson
        }
    }
}
</script>

<style scoped>
td {
    vertical-align: top;
    padding: 5px;
}

th {
    padding: 5px;
}

table.table-bordered {
    border-collapse: collapse;
}

.thead-light {
    background-color: lightgray;
}

table.table-bordered {
    border: 1px solid black;
    margin-top: 20px;
}

table.table-bordered>thead>tr>th {
    border: 1px solid black;
}

table.table-bordered>tbody>tr>td {
    border: 1px solid black;
}
</style>