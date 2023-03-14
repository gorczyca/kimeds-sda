<template>
    <div class="rdf-container" ref="container">
        <!-- {{ rdf }} -->
    </div>
</template>

<script>
import vis from 'vis'
import * as rdflib from 'rdflib'
import sdaJson from '/src/assets/sda.json'


// import { Serializer } from 'rdf-js'
// import { serialize } from 'rdf-serialize'


export default {
    name: 'RdfGraph',
    data() {
        return {
            nodes: new vis.DataSet([]),
            edges: new vis.DataSet([]),
            network: null,
            toggleVisDict: {

            }
        }
    },
    mounted() {
        this.draw()
    },
    methods: {
        draw() {
            const initiallyHidden = true

            const container = this.$refs.container;
            const rootNode = sdaJson.mitigation[0]

            // Create nodes and edges based on the tree data
            this.addTreeNodesAndEdges(rootNode, this.nodes, this.edges, 2, initiallyHidden);

            const children = this.nodes.get({
                filter: function (item) {
                    return item.id != rootNode.id
                }
            }).map((child) => child.id)

            // show the root
            this.nodes.update({ id: rootNode.id, hidden: false })

            // device specific hazard 
            const devSpecHazEntities = ['function', 'hazard', 'hazardousSituation', 'deviceComponent']
            const devSpecHazId = 'devSpecHaz1'

            this.nodes.add({
                id: devSpecHazId,
                label: 'Device specific hazard',
                level: 1
            })

            let devSpecHazChildren = []
            devSpecHazEntities.forEach(entity => {
                const entityId = sdaJson[entity].id
                devSpecHazChildren.push(entityId)
                this.nodes.add({
                    id: entityId,
                    label: `${this.camelToRegular(entity)}:\n${sdaJson[entity].name}`,
                    level: 0,
                    hidden: initiallyHidden
                })
                this.edges.add({
                    from: devSpecHazId,
                    to: entityId
                })
            })

            // risk
            const riskId = 'risk1'
            const preProbSevId = 'preProbSev1'
            const postProbSevId = 'postProbSev1'

            this.nodes.add([
                {
                    id: riskId,
                    label: 'Risk',
                    level: 1
                }, {
                    id: sdaJson.risk.harm.id,
                    label: `Harm:\n${sdaJson.risk.harm.name}`,
                    level: 0,
                    hidden: initiallyHidden
                }, {
                    id: sdaJson.risk.deviceContext.id,
                    label: `Device context:\n${sdaJson.risk.deviceContext.name}`,
                    level: 0,
                    hidden: initiallyHidden

                }, {
                    id: preProbSevId,
                    label: `Pre-mitigation\nProb: ${sdaJson.risk.probability}\nSev: ${sdaJson.risk.severity}`,
                    level: 0,
                    hidden: initiallyHidden

                }, {
                    id: postProbSevId,
                    label: `Post-mitigation\nProb: ${sdaJson.risk.postMitigationProbability}\nSev: ${sdaJson.risk.postMitigationSeverity}`,
                    level: 0,
                    hidden: initiallyHidden

                }])


            let riskChildren = [
                sdaJson.risk.harm.id,
                preProbSevId,
                sdaJson.risk.deviceContext.id,
                postProbSevId,
            ]

            riskChildren.forEach(childId => {
                this.edges.add({
                    from: riskId,
                    to: childId
                })
            })

            // connect the 3 entities
            this.edges.add([
                {
                    from: rootNode.id,
                    to: riskId
                },
                {
                    from: rootNode.id,
                    to: devSpecHazId
                },
                {
                    from: devSpecHazId,
                    to: riskId
                }
            ])






            this.toggleVisDict[rootNode.id] = {
                hidden: initiallyHidden,
                children: children
            }
            this.toggleVisDict[riskId] = {
                hidden: initiallyHidden,
                children: riskChildren
            }
            this.toggleVisDict[devSpecHazId] = {
                hidden: initiallyHidden,
                children: devSpecHazChildren
            }

            // Create a data object containing the nodes and edges
            const data = {
                nodes: this.nodes,
                edges: this.edges
            };
            // Create the network visualization
            const options = {
                physics: false,
                height: '800px',
                layout: {
                    hierarchical: {
                        direction: 'UD',
                    }
                }
            };
            this.network = new vis.Network(container, data, options)
            this.network.on('click', this.toggleVisibility)

        },

        addTreeNodesAndEdges(node, nodes, edges, level, initiallyHidden = false) {
            // Add the current node to the nodes array
            nodes.add({
                id: node.id,
                label: node.name,
                level: level,
                hidden: initiallyHidden
            });

            // Add edges to parent nodes
            if (node.children) {
                node.children.forEach(child => {
                    edges.add({
                        from: node.id,
                        to: child.id
                    });

                    // Recursively add child nodes and edges
                    this.addTreeNodesAndEdges(child, nodes, edges, level + 1, initiallyHidden);
                });
            }
        },

        toggleVisibility(event) {
            const nodes = this.nodes
            const nodeId = event.nodes[0]
            if (nodeId in this.toggleVisDict) {
                let hidden = !this.toggleVisDict[nodeId].hidden
                
                this.toggleVisDict[nodeId].children.forEach(function (childId) {
                    nodes.update([{ id: childId, hidden: hidden }])
                })

                this.toggleVisDict[nodeId].hidden = hidden
            }
            // this.network.fit()
        },

        camelToRegular(camelCaseText) {
            // Replace uppercase letters with a space and the lowercase version of the letter
            let regularText = camelCaseText.replace(/[A-Z]/g, (match) => ` ${match.toLowerCase()}`);

            // Capitalize the first letter of each word
            regularText = regularText.replace(/\b\w/g, (match) => match.toUpperCase());

            return regularText;
        },
    },
}
</script>

<style scoped>
.rdf-container {
    min-height: 900px;
    width: 100%;
}

.vis-network {
    min-height: 900px !important;
}

canvas {
    height: 100% !important;
}
</style>
