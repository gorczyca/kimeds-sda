<template>
    <td>
        <h4>Context: {{ risk.deviceContext.name }}</h4>
        <p> {{ risk.deviceContext.description }} </p>
        <br />
        <h4>Harm: {{ risk.harm.name }} </h4>
        <p> {{ risk.harm.description }} </p>
        <br />

        <table >
            <thead>
                <tr>
                    <th>
                        Pre-mitigation assessment:
                    </th>
                    <th width="15px"></th>
                    <th>
                        Post-mitigation assessment:
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <div
                            :class="risk.probability == 'high' || risk.severity == 'high' ? 'high-risk risk' : 'acceptable-risk risk'">
                            Probability: <b>{{ risk.probability }}</b><br />
                            Severity: <b>{{ risk.severity }}</b>
                    </div>
                    </td>
                    <td></td>
                    <td>
                        <div
                            :class="risk.postMitigationProbability == 'high' || risk.postMitigationSeverity == 'high' ? 'high-risk risk' : 'acceptable-risk risk'">
                            Probability: <b>{{ risk.postMitigationProbability }}</b><br/>
                            Severity: <b>{{ risk.postMitigationSeverity }}</b>
                    </div>
                    </td>
                </tr>
            </tbody>
        </table>


    </td>
</template>

<script>
export default {
    props: {
        risk: {
            type: Object,
            default: {
                harm: {
                    name: "Harm name",
                    description: "Harm description"
                },
                probability: "Probability",
                severity: "Severity",
                deviceContext: {
                    name: "Device context name",
                    description: "Device context description"
                }

            }
        }
    }
}
</script>

<style>

table.risk-assessment > td {
    margin: 10px;
}
div.risk {
    border: 1px solid black;
    padding: 2px;
}

.high-risk {
    background-color: #ffb2ae;
}

.acceptable-risk {
    background-color: #ddf6dd;
}
</style>