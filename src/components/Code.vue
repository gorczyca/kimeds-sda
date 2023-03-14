<script setup>
import Tab from './Tab.vue'
import Tabs from './Tabs.vue'
</script>

<template>
    <div>
        <Tabs class="code-tabs">
            <Tab title="RDF">
                <highlightjs autodetect :code="codeRDF" />
            </Tab>
            <Tab title="XML">
                <highlightjs autodetect :code="codeXML" />
            </Tab>
            <Tab title="JSON">
                <highlightjs autodetect :code="codeJSON" />
            </Tab>
        </Tabs>
    </div>
</template>

<script>
import * as rdflib from 'rdflib'
import sdaJson from '/src/assets/sda.json'

export default {
    name: 'Code',
    components: {
        Tab,
        Tabs,
    },
    computed: {
        codeJSON: function () {
            return JSON.stringify(sdaJson, null, 2)
        },
        codeRDF: function() {
            return this.jsonToRDF(sdaJson)
        },
        codeXML: function () {
            const store = rdflib.graph()
            rdflib.parse(this.codeRDF, store, 'http://example.org/', 'text/turtle')
            return rdflib.serialize(undefined, store, '', 'application/rdf+xml');
        }
    },
    methods: {
        getStore: function () {
            const store = rdflib.graph()
            rdflib.parse(this.rdfCode, store, 'http://example.org/', 'text/turtle')
            return store
        },
        jsonToRDF(jsonObject) {
            const prefix = 'ex'
            let rdfString = `@prefix ${prefix}:	<http://example.org/> .\n\n`
            rdfString += `${prefix}:device ${prefix}:hasManagedRisk [\n`
            rdfString += this.jsonToRDFRec(jsonObject, 1, prefix)
            rdfString += '] .\n'
            return rdfString
        },
        jsonToRDFRec(jsonObject, depth = 0, prefix = '') {
            let turtleTriples = "";
            let enumeration = null;
            let separator = null
            let itemsLength = Object.entries(jsonObject).length
            let index = 0

            if (Array.isArray(jsonObject)) {
                separator = ', ',
                    enumeration = true
            }
            else {
                separator = ';'
                enumeration = false
            }

            // Convert JSON object to Turtle triples
            for (const [key, value] of Object.entries(jsonObject)) {

                index++
                if (index === itemsLength) separator = ''

                // else separator = ','



                if (typeof value === "object" && value !== null) {
                    // If value is an object, recursively convert it to Turtle triples
                    const nestedTurtle = this.jsonToRDFRec(value, depth + 1, prefix);
                    if (enumeration) {
                        turtleTriples += `\n${"  ".repeat(depth)} [\n${nestedTurtle} ${"  ".repeat(depth)}] ${separator}`;
                    } else {
                        if (Array.isArray(value)) {
                            turtleTriples += "  ".repeat(depth) + `${prefix}:${key} ${nestedTurtle}${"  ".repeat(depth)} ${separator}\n`;
                        } else {
                            turtleTriples += "  ".repeat(depth) + `${prefix}:${key} [\n${nestedTurtle}${"  ".repeat(depth)}] ${separator}\n`;
                        }
                    }
                } else {
                    // If value is a string, number, or boolean, create a simple Turtle triple
                    if (value !== null) {
                        const object = typeof value === "string" ? `"${value}"` : value;
                        turtleTriples += "  ".repeat(depth) + `${prefix}:${key} ${object} ${separator}\n`;
                    }
                }
            }

            return turtleTriples;

        }

    }

}
</script>

<style>
div.code-tabs>ul {
    /* text-align: center; */
}

div.code-tabs>ul>li {
    padding: 8px 15px;
    margin: 0 3px;
}

div.code-tabs>ul>li:hover {
    /* background-color: white; */
    /* text-decoration: underline; */
    font-weight: bold;

}

div.code-tabs>ul>li.tabs__selected {
    /* text-decoration: underline; */
    font-weight: bold;
    text-decoration-line: underline;
    text-decoration-thickness: 3px;
}
</style>