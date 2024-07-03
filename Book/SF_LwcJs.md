### [SF Book](../README.md)

# [Lightning Web Components](./SF_LWC.md)

### Getting components by Id

    <canvas data-id="myChart"></canvas>

    const ctx = this.template.querySelector('[data-id="myChart"]').getContext('2d');

### Getting record Id
To get the id of a record page's record, the api variable recordId can be used.

    @api recordId;

Note that this doesn't work for nested components. For those cases "CurrentPageReference" can be used to obtain information.

    import {CurrentPageReference} from 'lightning/navigation';

    @api recordIdFromPage;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference)
    {
        if (currentPageReference)
        {
            console.log(JSON.stringify(currentPageReference));
            this.recordIdFromPage = currentPageReference.attributes.recordId;
        }
    }

    // Sample currentPageReference object
    {"type":"standard__recordPage","attributes":{"objectApiName":"Account","recordId":"0017Q00000NkNqZQAV","actionName":"view"},"state":{}}

### Invoking Apex
To call an Apex method it must implement the "@AuraEnabled(cacheable=true)" tag, then it can be imported and called in the component's JS file.

NOTE: Parameters are passed as an object.

    // Apex
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsWithNames(integer count)
    {
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT :count];
        return accounts;
    }

    // JS
    import getAccounts from '@salesforce/apex/LWC_testLwc.getAccountsWithNames';
    // ...
    async apexCallWithParams()
    {
        console.log("Fetching accounts...");
        try {
            this.accounts = await getAccounts({ count: 10 });
            console.log(this.accounts);
        }
        catch (error) {
            console.log("ERROR: " + JSON.stringify(error));
        }
    }

### Using other JS files

    // generateData.js
    export default function generateData({ amountOfRecords }) {
        return [...Array(amountOfRecords)].map((_, index) => {
            return {
                name: `Name (${index})`,
                website: 'www.salesforce.com',
                amount: Math.floor(Math.random() * 100),
                phone: `${Math.floor(Math.random() * 9000000000) + 1000000000}`,
                closeAt: new Date(
                    Date.now() + 86400000 * Math.ceil(Math.random() * 20)
                ),
            };
        });
    }

    // main.js
    import generateData from './generateData';

    const data = generateData({ amountOfRecords: 100 });

## Decorators

Note: Decorators require importing.

    import { LightningElement, api, wire } from "lwc";

### Api
The "@api" tag can be used to expose a component's variables and methods.

    // todoItem.js
    import { LightningElement, api } from "lwc";
    export default class TodoItem extends LightningElement {
    @api itemName = "New Item";
    }


    <!-- todoItem.html -->
    <template>
    <div class="view">
        <label>{itemName}</label>
    </div>
    </template>

### Track
The "@track" tag can be used to make certain types of variables reactive. To be specific it's required for object properties and elements of an array. (The others are already reactive)

### Wire
Used to obtain system data and call Apex methods.

NOTES:

- Wires are great for read operations to keep data updated but they should not be used for other operations.
- Wires are executed whenever the input parameter changes (One of the tracked Properties). If an update has to occur for other operations events are needed.

Set a variable from an Apex method call (Note: this is done after connectedCallback)

    import { LightningElement, wire } from 'lwc';
    import getAccounts from '@salesforce/apex/LWC_testLwc.get10AccountsWithNames';

    @wire(getAccounts) wiredAccounts

With Params:

    @wire(getAccounts2, {count: '$accountCount'}) wiredAccountsWithParams; // $ makes it update whenever the variable is changed

Salesforce has a series of adapters that can be used with wires such as getRecord:

    import { getRecord } from 'lightning/uiRecordApi';
    import NAME_FIELD from '@salesforce/schema/Account.Name'

    @wire(getRecord, { recordId: '$recordIdFromPage', fields: [NAME_FIELD] }) record;

To refresh wired data refreshApex can be used:

    import { refreshApex } from '@salesforce/apex';

    async handleClick(e) {
        try {
        await updateOpptyStage({
            amount: this.amount,
            stage: "Closed Won",
        });
        await refreshApex(this.opptiesOverAmount);
        } catch (error) {
        this.message =
            "Error received: code" + error.errorCode + ", " + "message " + error.body.message;
        }
    }