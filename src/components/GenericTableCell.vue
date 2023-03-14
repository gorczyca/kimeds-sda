<template>
    <div>
        <h4>{{ title }}: {{ data.name }}</h4>

        <p>{{ data.description }}</p>
        <br/>
    </div>
</template>


<script>
export default {
    props: {
        data: {
            type: Object,
            default:  {
                name: "Object name",
                description: "Object description",
            }
        },
        title: {
            type: String,
            default: "Title"
        }

    }
}
</script>