import { LightningElement, api } from 'lwc';
import getAccounts from '@salesforce/apex/LWC_testLwc.get10AccountsWithNames';
import getAccounts2 from '@salesforce/apex/LWC_testLwc.getAccountsWithNames';

export default class TestLwc extends LightningElement
{
    @api recordId; // Used by default
    accounts;

    async apexCall()
    {
        console.log("Fetching 10 accounts...");
        try {
            this.accounts = await getAccounts();
            console.log(this.accounts);
        }
        catch (error) {
            console.log("ERROR: " + JSON.stringify(error));
        }
    }

    async apexCallWithParams()
    {
        console.log("Fetching accounts...");
        try {
            this.accounts = await getAccounts2({ count: 10 });
            console.log(this.accounts);
        }
        catch (error) {
            console.log("ERROR: " + JSON.stringify(error));
        }
    }
}