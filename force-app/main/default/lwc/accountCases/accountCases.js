import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
//import generateData from './generateData';
import getAccountCases from '@salesforce/apex/LWC_accountCases.getAccountCases';

const columns = [
    { label: 'Id', fieldName: 'Id' },
    { label: 'Subject', fieldName: 'Subject' },
    { label: 'Created Date', fieldName: 'CreatedDate', type: 'date' },
    // { label: 'Subject', fieldName: 'subject', type: 'url' },
    // { label: 'Phone', fieldName: 'phone', type: 'phone' },
    // { label: 'Balance', fieldName: 'amount', type: 'currency' },
    // { label: 'CloseAt', fieldName: 'closeAt', type: 'date' },
];

export default class AccountCases extends LightningElement
{
    //data = [];
    @api cases = [];
    columns = columns;

    recordIdFromPage;

    @wire(getAccountCases, { accountId: '$recordIdFromPage' })
    wiredCases({ error, data })
    {
        if (data)
        {
            this.cases = data;
            this.error = undefined;
        }
        else if (error)
        {
            this.error = error;
            this.cases = undefined;
        }
    }

    connectedCallback() {
        //const data = generateData({ amountOfRecords: 100 });
        //this.data = data;
    }

    @wire(CurrentPageReference)
    loadCurrentPageInfo(currentPageReference)
    {
        if (currentPageReference)
        {
            this.recordIdFromPage = currentPageReference.attributes.recordId;
        }
    }

    printCases(){
        console.log('cases: ' + JSON.stringify(this.cases));
    }
}