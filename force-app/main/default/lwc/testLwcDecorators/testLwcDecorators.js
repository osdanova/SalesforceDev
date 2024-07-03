import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getAccounts from '@salesforce/apex/LWC_testLwc.get10AccountsWithNames';
import getAccounts2 from '@salesforce/apex/LWC_testLwc.getAccountsWithNames';
import { getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Account.Name'

export default class TestLwcDecorators extends LightningElement
{
    @api recordIdFromPage;
    @api counter;
    @wire(getAccounts) wiredAccounts;
    @wire(getAccounts2, {count: '$counter'}) wiredAccountsWithParams; // $ makes it update whenever the variable is changed
    @wire(getRecord, { recordId: '$recordIdFromPage', fields: [NAME_FIELD] }) record;

    // Called before rendering
    connectedCallback()
    {
        if(!this.counter){
            this.counter = 0;
        }
        if(this.wiredAccounts){
            console.log('Wired Accounts: ' + JSON.stringify(this.wiredAccounts));
        }
    }

    increaseCount()
    {
        this.counter++;
        console.log('Record: ' + JSON.stringify(this.record));
        console.log('Wired Accounts: ' + JSON.stringify(this.wiredAccounts));
        console.log('Wired Accounts with params: ' + JSON.stringify(this.wiredAccountsWithParams));
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference)
    {
        if (currentPageReference)
        {
            //console.log(JSON.stringify(currentPageReference));
            this.recordIdFromPage = currentPageReference.attributes.recordId;
        }
    }
}