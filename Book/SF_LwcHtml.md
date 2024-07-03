### [SF Book](../README.md)

# [Lightning Web Components](./SF_LWC.md)

### Using js variables in the html file

    <p>Counter: {counter}</p>
    <button onclick={increaseCount}>Increase count</button>

### Using other LWCs
Other components can be inserted by using the "c-" tag. Note that upper characters are replaced with lower characters preceded by a dash. Exposed variables (api decorator) from the component can be set when inserting it.

    <!-- Insert testLwcDecorators -->
    <c-test-lwc-decorators counter=5></c-test-lwc-decorators>

### Conditional rendering

    <div if:true={isPersonAccount}>