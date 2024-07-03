### [SF Book](../README.md)

# [Lightning Web Components](./SF_LWC.md)

## Adding a JS Library

- Get the library as a distributable js file (Check [JsDelivr](https://www.jsdelivr.com))
- Upload as Static Resource
- Import in your js file and the SF methods to use it

    import { loadStyle, loadScript } from "lightning/platformResourceLoader";

- Start the library's scripts and styles through loadScript(this, MY_LIB) and loadStyle(this, MY_LIB)

## Chart.Js Example

Link to distributable version: https://www.jsdelivr.com/package/npm/chart.js?path=dist

    import chartjs from '@salesforce/resourceUrl/JS_ChartJs_2_8_0';
    import { loadStyle, loadScript } from "lightning/platformResourceLoader";
    
    async renderedCallback()
    {
        try
        {
            await Promise.all([this.loadCases(), loadScript(this, chartjs)]).then(() =>
            {
                this.loadGraph();
            })
            .catch(error => {
                this.displayError(error);
            });
            console.log("Promise finished");
        }
        catch (error) {
        }
    }

    loadGraph()
    {
        const ctx = this.template.querySelector('[data-id="myChart"]').getContext('2d');
        this.chart = new window.Chart(ctx, this.chartConfig);
    }