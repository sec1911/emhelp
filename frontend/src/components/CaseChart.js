import React, { useState } from 'react';
import { Chart } from 'primereact/chart';

const CaseChart = () => {
    const [chartData] = useState({
        labels: ['Total', 'New', 'Active',  'Closed'],
        datasets: [
            {
                data: [5, 3, 1, 1],
                backgroundColor: [
                    "#FFCE56",
                    "#FF6384",
                    "#36A2EB",
                    "#0ce378"
                ],
                hoverBackgroundColor: [
                    "#FFCE56",
                    "#FF6384",
                    "#36A2EB",
                    "#0ce378"
                ]
            }]
    });

    const [lightOptions] = useState({
        plugins: {
            legend: {
                labels: {
                    color: '#495057'
                }
            }
        }
    });

    return (
        <div className="card flex justify-content-center" style={{marginTop: '25px', marginLeft: '150px'}}>
            <Chart type="doughnut" data={chartData}  style={{  }} />
        </div>
    )
}

export default CaseChart;