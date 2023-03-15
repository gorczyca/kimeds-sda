<template>
    <div class="rdf-container" ref="container">
        <!-- {{ rdf }} -->
    </div>
</template>

<script>
import vis from 'vis'
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
            const initiallyHidden = false

            const container = this.$refs.container;
            const mitigationId = 'mitigation1'
            const rootNode = sdaJson.mitigation[0]
            const mitigationNodeColor = '#cde6ff'
            const importantNodeFontSize = 20

            // Create nodes and edges based on the tree data
            // TODO: modify it so that you can have more siblings of the root node
            this.addTreeNodesAndEdges(rootNode, this.nodes, this.edges, 3, initiallyHidden);
            const mitigationChildren = this.nodes.map((child) => child.id)


            this.nodes.add({
                id: mitigationId,
                label: '<b>Mitigation</b>',
                level: 2,
                color: mitigationNodeColor,
                font: {
                    size: importantNodeFontSize
                }
            })

            this.edges.add({
                from: mitigationId,
                to: rootNode.id
            })

            // device specific hazard 
            const devSpecHazEntities = ['function', 'hazard', 'hazardousSituation', 'deviceComponent']
            const devSpecHazId = 'devSpecHaz1'
            const devSpecHazColor = '#ebe5f5'


            this.nodes.add({
                id: devSpecHazId,
                label: '<b>Device specific hazard</b>',
                level: 1,
                color: devSpecHazColor,
                font: {
                    size: importantNodeFontSize
                }
            })

            let devSpecHazChildren = []
            devSpecHazEntities.forEach(entity => {
                const entityId = sdaJson[entity].id
                devSpecHazChildren.push(entityId)
                this.nodes.add({
                    id: entityId,
                    label: `<i>(${this.camelToRegular(entity)})</i>\n<b>${sdaJson[entity].name}</b>`,
                    level: 0,
                    hidden: initiallyHidden,
                    color: devSpecHazColor
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

            // colors
            const postMitigationColor = '#cdffcd'
            const preMitigationColor = '#ffb4b4'
            const riskColor = '#f2f2f2'
            this.nodes.add([
                {
                    id: riskId,
                    label: '<b>Risk</b>',
                    level: 1,
                    font: {
                        size: importantNodeFontSize
                    },
                    color: riskColor
                }, {
                    id: sdaJson.risk.harm.id,
                    label: `<i>(Harm)</i>\n<b>${sdaJson.risk.harm.name}</b>`,
                    level: 0,
                    hidden: initiallyHidden,
                    color: riskColor
                }, {
                    id: sdaJson.risk.deviceContext.id,
                    label: `<i>(Device context)</i>\n<b>${sdaJson.risk.deviceContext.name}</b>`,
                    title: 'This will be a tooltip',
                    level: 0,
                    hidden: initiallyHidden,
                    color: riskColor


                }, {
                    id: preProbSevId,
                    label: `<i>(Pre-mitigation)</i>\n<b>Prob:${sdaJson.risk.probability}</b>\n<b>Sev: ${sdaJson.risk.severity}</b>`,
                    level: 0,
                    hidden: initiallyHidden,
                    color: preMitigationColor

                }, {
                    id: postProbSevId,
                    label: `<i>(Post-mitigation)</i>\n<b>Prob: ${sdaJson.risk.postMitigationProbability}</b>\n<b>Sev: ${sdaJson.risk.postMitigationSeverity}</b>`,
                    level: 0,
                    hidden: initiallyHidden,
                    color: postMitigationColor

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
                    from: mitigationId,
                    to: riskId
                },
                {
                    from: mitigationId,
                    to: devSpecHazId
                },
                {
                    from: devSpecHazId,
                    to: riskId
                }
            ])






            this.toggleVisDict[mitigationId] = {
                hidden: initiallyHidden,
                children: mitigationChildren
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
                nodes: {
                    shape: 'box',
                    font: { multi: true, size: 16 },
                    widthConstraint: { maximum: 150, minimum: 75 },
                    heightConstraint: { minimum: 30 },
                    margin: 10,
                },
                edges: {
                    color: {
                        inherit: false,
                        color: 'black'
                    }
                },
                physics: false,
                height: '800px',
                layout: {
                    hierarchical: {
                        levelSeparation: 100,
                        direction: 'UD',
                        nodeSpacing: 150
                    }
                }
            };
            this.network = new vis.Network(container, data, options)
            this.network.on('click', this.toggleVisibility)

        },

        addTreeNodesAndEdges(node, nodes, edges, level, initiallyHidden = false) {
            // Add the current node to the nodes array

            function getTypeColor(type) {
                return type === 'implementationManifest' ? implementationManifestColor : type === 'assuranceSda' ? assuranceSdaColor : riskSdaColor
            }

            const implementationManifestColor = '#f1fbf1'
            const riskSdaColor = '#cde6ff'
            const assuranceSdaColor = '#ffffe7'

            nodes.add({
                id: node.id,
                label: `<i>(${this.camelToRegular(node.type)})</i>\n<b>${node.name}</b>`,
                level: level,
                hidden: initiallyHidden,
                color: getTypeColor(node.type),
            });

            // Add edges to parent nodes
            if (node.children) {
                node.children.forEach(child => {
                    edges.add({
                        from: node.id,
                        to: child.id,
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
