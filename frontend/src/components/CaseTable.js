import 'primeicons/primeicons.css';
import 'primereact/resources/themes/lara-light-indigo/theme.css';
import 'primereact/resources/primereact.css';

import { useNavigate} from "react-router-dom";
import React, { useState, useEffect  } from 'react';
import { DataTable } from 'primereact/datatable';
import { Column } from 'primereact/column';
import { Button } from 'primereact/button';
import { Calendar } from 'primereact/calendar';
import '../design/DataTableDemo.css';
import Dashboard from "./Dashboard";

const CaseTable = ({dataset}) => {
    const [cases, setCases] = useState(null);
    const navigate = useNavigate();

    useEffect(() => {
        /*CaseService.getCases().then(
            (res) => {
                setCases(res.data)
            }
        );*/
        document.body.style.backgroundColor = "#e3e3d1"
    }, []); // eslint-disable-line react-hooks/exhaustive-deps


    const renderHeader = () => {
        return (
            <div className="flex justify-content-between align-items-center">
                <h5 className="m-0" >New Cases</h5>
            </div>
        )
    }

    const dateFilterTemplate = (options) => {
        return <Calendar value={options.value} onChange={(e) => options.filterCallback(e.value, options.index)} dateFormat="mm/dd/yy" placeholder="mm/dd/yyyy" mask="99/99/9999" />
    }

    const forwardDetailPage = (caseDescription) => {
        navigate('/case', { state: {caseDescription}});
    }

    const actionBodyTemplate = (rowData) => {
        return <Button onClick={ () => forwardDetailPage(rowData)} className="p-button-rounded p-button-success p-mr-2" icon="pi pi-arrow-circle-right"/>;
    }

    const header = renderHeader();

    const getName = (rowData) => {

        const opened_by = rowData.opened_by;

        return (
            <React.Fragment>
                <h5>{opened_by.name}</h5>
            </React.Fragment>
        );
    }

    const messageBodyTemplate = (rowData) => {
        return <span ><p>{rowData.message}</p></span>;
    }

    const statusBodyTemplate = (rowData) => {
        const stat = rowData.is_active === true ? 'active' : 'inactive';
        return <span className={`case-badge status-${stat}`}>{stat}</span>;
    }

    const activityBodyTemplate = (rowData) => {
        const stat = rowData.action_taken === true ? 'action' : 'no_action';
        return <span className={`case-badge activity-${stat}`}>{stat}</span>;
    }

    return (
        <div className="datatable-doc-demo" style={{marginTop: 85}}>
            <Dashboard/>
            <div className="card">
                <DataTable value={dataset} paginator className="p-datatable-customers" header={header} rows={10}
                           paginatorTemplate="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport RowsPerPageDropdown" rowsPerPageOptions={[5,10,25,50]}
                           dataKey="id" rowHover
                           responsiveLayout="scroll"

                           currentPageReportTemplate="Showing {first} to {last} of {totalRecords} entries">
                    <Column body={getName} header="Name" style={{ minWidth: '14rem' }} />
                    <Column field="date_created" header="Date" sortable filterField="date" dataType="date" style={{ minWidth: '8rem' }}
                            filter filterElement={dateFilterTemplate} />
                    <Column field="message"  header="Message" body={messageBodyTemplate} style={{ width: 10, whiteSpace: 'normal' }} />
                    <Column field="is_active" header="Status" sortable body={statusBodyTemplate} filterMenuStyle={{ width: '14rem' }} style={{ minWidth: '10rem' }}  />
                    <Column field="action_taken" header="Activity" body={activityBodyTemplate} showFilterMatchModes={false} style={{ minWidth: '10rem' }} />
                    <Column headerStyle={{ width: '4rem', textAlign: 'center' }} header="Detail" bodyStyle={{ textAlign: 'center', overflow: 'visible' }} body={actionBodyTemplate} />
                </DataTable>
            </div>
        </div>
    );
}

export default CaseTable;