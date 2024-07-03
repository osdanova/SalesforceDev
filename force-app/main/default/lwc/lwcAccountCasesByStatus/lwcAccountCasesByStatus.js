import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import chartjs from '@salesforce/resourceUrl/JS_ChartJs';
import { loadStyle, loadScript } from "lightning/platformResourceLoader";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccountCasesByStatus from '@salesforce/apex/LWC_accountCasesByStatus.getAccountCasesByStatus';

export default class LwcAccountCasesByStatus extends LightningElement
{
    recordIdFromPage;
    chart;
    caseCountByStatus;

    chartConfig =
    {
        type: 'bar',
        data: {
            labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
            datasets: [{
                label: '# of Cases',
                data: [12, 19, 3, 5, 2, 3],
                borderWidth: 1
            }]
        },
        options: {
            responsive: false,
            scales: {
                y: {
                    ticks: {
                        stepSize: 1
                    }
                },
              }
        }
    };

    @wire(CurrentPageReference)
    async loadCurrentPageInfo(currentPageReference)
    {
        console.log("[LwcAccountCasesByStatus] Loading Account id...");
        if (currentPageReference) {
            this.recordIdFromPage = currentPageReference.attributes.recordId;
        }
        console.log("[LwcAccountCasesByStatus] Account id: " + this.recordIdFromPage);
    }

    async renderedCallback()
    {
        this.renderGraph();
    }

    async renderGraph()
    {
        try
        {
            console.log("[LwcAccountCasesByStatus] Starting promise...");
            await Promise.all([this.loadCases(), loadScript(this, chartjs)]).then(() =>
            {
                this.loadGraph();
            })
            .catch(error => {
                this.displayError(error);
            });
            console.log("[LwcAccountCasesByStatus] Promise finished");
        }
        catch (error) {
            this.displayError(error);
        }
    }

    loadGraph()
    {
        console.log("[LwcAccountCasesByStatus] Loading graph...");
        
        this.loadChartData();
        console.log("[LwcAccountCasesByStatus] Graph chartConfig: " + JSON.stringify(this.chartConfig));

        const ctx = this.template.querySelector('[data-id="myChart"]').getContext('2d');
        this.chart = new window.Chart(ctx, this.chartConfig);
        console.log("[LwcAccountCasesByStatus] Graph loaded");
    }

    loadChartData()
    {
        this.chartConfig.data.labels = [];
        this.chartConfig.data.datasets[0] = [];

        let datasetData = [];
        for (var prop in this.caseCountByStatus)
        {
            if (Object.prototype.hasOwnProperty.call(this.caseCountByStatus, prop))
            {
                this.chartConfig.data.labels.push(prop);
                datasetData.push(this.caseCountByStatus[prop]);
            }
        }
        
        this.chartConfig.data.datasets = [];
        this.chartConfig.data.datasets.push({
            label: '# of Cases',
            data: datasetData,
            borderWidth: 1
        });
    }

    async loadCases()
    {
        console.log("[LwcAccountCasesByStatus] Loading Cases from account: " + this.recordIdFromPage);
        let data = await getAccountCasesByStatus({ accountId: this.recordIdFromPage });
        this.caseCountByStatus = data;
        console.log("[LwcAccountCasesByStatus] Case count by status: " + JSON.stringify(this.caseCountByStatus));
    }

    displayError(error)
    {
        this.dispatchEvent(
            new ShowToastEvent({
            title: "Error loading ChartJS",
            message: error.message,
            variant: "error",
            }),
        );
    }
}