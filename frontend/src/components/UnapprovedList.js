import 'primeicons/primeicons.css';
import 'primereact/resources/themes/lara-light-indigo/theme.css';
import 'primereact/resources/primereact.css';
import 'primeflex/primeflex.css';
import '../index.css';

import React, { useState, useEffect, useRef } from 'react';
import { DataTable } from 'primereact/datatable';
import { Column } from 'primereact/column';
import { Toast } from 'primereact/toast';
import { Button } from 'primereact/button';
import { Toolbar } from 'primereact/toolbar';
import { Dialog } from 'primereact/dialog';
import { InputText } from 'primereact/inputtext';
import '../design/DataTableDemo.css'
import UserService from "../services/UserService";
import Dashboard from "./Dashboard";

const UnapprovedList = () => {

    let emptyCrew = {
        id: null,
        name: '',
        description: '',
        category: null,
        quantity: 0,
    };

    const [crews, setCrews] = useState(null);
    const [crewDialog, setCrewDialog] = useState(false);
    const [deleteCrewDialog, setDeleteCrewDialog] = useState(false);
    const [deleteCrewsDialog, setDeleteCrewsDialog] = useState(false);
    const [acceptCrewDialog, setAcceptCrewDialog] = useState(false);
    const [acceptCrewsDialog, setAcceptCrewsDialog] = useState(false);
    const [crew, setCrew] = useState(emptyCrew);
    const [selectedCrews, setSelectedCrews] = useState(null);
    const [submitted, setSubmitted] = useState(false);
    const [globalFilter, setGlobalFilter] = useState(null);
    const toast = useRef(null);
    const dt = useRef(null);

    useEffect(() => {
        takeApply();
        document.body.style.backgroundColor = "#e3e3d1"
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

    const takeApply = () => {
        UserService.getUnapprovedList().then(
            (res) => {
                setCrews(res.data)
            });
    }

    const hideDialog = () => {
        setSubmitted(false);
        setCrewDialog(false);
    }

    const hideAcceptCrewDialog = () => {
        setAcceptCrewDialog(false);
    }

    const hideAcceptCrewsDialog = () => {
        setAcceptCrewsDialog(false);
    }

    const hideDeleteCrewDialog = () => {
        setDeleteCrewDialog(false);
    }

    const hideDeleteCrewsDialog = () => {
        setDeleteCrewsDialog(false);
    }

    const acceptCrew = () => {
        let _crews = crews.filter(val => val.id !== crew.id);
        setCrews(_crews);
        console.log(crews)
        UserService.postApprovedUser(crews[0].id).then(
            (response) =>{
                takeApply();
            }
        )
        setDeleteCrewDialog(false);
        setCrew(emptyCrew);
        toast.current.show({ severity: 'success', summary: 'Successful', detail: 'Unit Accepted', life: 3000 });
    }

    const deleteCrew = () => {
        /*let _products = products.filter(val => val.id !== product.id);
        setProducts(_products);*/
        setDeleteCrewDialog(false);
        setCrew(emptyCrew);
        toast.current.show({ severity: 'success', summary: 'Successful', detail: 'Unit Deleted', life: 3000 });
    }

    const confirmAcceptSelected = () => {
        setAcceptCrewsDialog(true);
    }

    const confirmDeleteSelected = () => {
        setDeleteCrewsDialog(true);
    }

    const acceptSelectedCrews = () => {
        /*let _products = products.filter(val => !selectedProducts.includes(val));
        setProducts(_products);*/
        let _crews = crews.filter(val => val.id !== crew.id);
        setCrews(_crews);
        console.log(crews[0])
        UserService.postApprovedUser(crews[0].id).then(
            (response) =>{
                takeApply();
            }
        )
        setAcceptCrewsDialog(false);
        setSelectedCrews(null);
        toast.current.show({ severity: 'success', summary: 'Successful', detail: 'Units Approved', life: 3000 });
    }

    const deleteSelectedCrews = () => {
        /*let _products = products.filter(val => !selectedProducts.includes(val));
        setProducts(_products);*/
        setDeleteCrewsDialog(false);
        setSelectedCrews(null);
        toast.current.show({ severity: 'success', summary: 'Successful', detail: 'Units Deleted', life: 3000 });
    }

    const leftToolbarTemplate = () => {
        return (
            <React.Fragment>
                <Button label="Accept" icon="pi pi-plus" className="p-button-success mr-2" onClick={confirmAcceptSelected} disabled={!selectedCrews || !selectedCrews.length} />
                <Button label="Delete" icon="pi pi-trash" className="p-button-danger" onClick={confirmDeleteSelected} disabled={!selectedCrews || !selectedCrews.length} />
            </React.Fragment>
        )
    }

    const header = (
        <div className="table-header">
            <h5 className="mx-0 my-1">Manage Crews</h5>
            <span className="p-input-icon-left">
                <i className="pi pi-search" />
                <InputText type="search" onInput={(e) => setGlobalFilter(e.target.value)} placeholder="Search..." />
            </span>
        </div>
    );
    const acceptCrewDialogFooter = (
        <React.Fragment>
            <Button label="No" icon="pi pi-times" className="p-button-text" onClick={hideAcceptCrewDialog} />
            <Button label="Yes" icon="pi pi-check" className="p-button-text" onClick={acceptCrew} />
        </React.Fragment>
    );
    const acceptCrewsDialogFooter = (
        <React.Fragment>
            <Button label="No" icon="pi pi-times" className="p-button-text" onClick={hideAcceptCrewsDialog} />
            <Button label="Yes" icon="pi pi-check" className="p-button-text" onClick={acceptSelectedCrews} />
        </React.Fragment>
    );
    const deleteCrewDialogFooter = (
        <React.Fragment>
            <Button label="No" icon="pi pi-times" className="p-button-text" onClick={hideDeleteCrewDialog} />
            <Button label="Yes" icon="pi pi-check" className="p-button-text" onClick={deleteCrew} />
        </React.Fragment>
    );
    const deleteCrewsDialogFooter = (
        <React.Fragment>
            <Button label="No" icon="pi pi-times" className="p-button-text" onClick={hideDeleteCrewsDialog} />
            <Button label="Yes" icon="pi pi-check" className="p-button-text" onClick={deleteSelectedCrews} />
        </React.Fragment>
    );

    return (
        <div className="datatable-crud-demo" style={{marginTop: 85}}>
            <Dashboard/>
            <Toast ref={toast} />

            <div className="card">
                <Toolbar className="mb-4" left={leftToolbarTemplate} ></Toolbar>

                <DataTable ref={dt} value={crews} selection={selectedCrews} onSelectionChange={(e) => setSelectedCrews(e.value)}
                           dataKey="id" paginator rows={10} rowsPerPageOptions={[5, 10, 25]}
                           paginatorTemplate="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport RowsPerPageDropdown"
                           currentPageReportTemplate="Showing {first} to {last} of {totalRecords} products"
                           globalFilter={globalFilter} header={header} responsiveLayout="scroll">
                    <Column selectionMode="multiple" headerStyle={{ width: '3rem' }} exportable={false}></Column>
                    <Column field="social_security_number" header="Social Security Number" sortable style={{ minWidth: '12rem' }}></Column>
                    <Column field="email" header="Email" sortable style={{ minWidth: '16rem' }}></Column>
                    <Column field="wants_to_be" header="Unit Type" sortable style={{ minWidth: '10rem' }}></Column>
                </DataTable>
            </div>

            <Dialog visible={acceptCrewDialog} style={{ width: '450px' }} header="Confirm" modal footer={acceptCrewDialogFooter} onHide={hideAcceptCrewDialog}>
                <div className="confirmation-content">
                    <i className="pi pi-exclamation-triangle mr-3" style={{ fontSize: '2rem'}} />
                    {crew && <span>Are you sure you want to accept <b>{crew.name}</b>?</span>}
                </div>
            </Dialog>

            <Dialog visible={acceptCrewsDialog} style={{ width: '450px' }} header="Confirm" modal footer={acceptCrewsDialogFooter} onHide={hideAcceptCrewsDialog}>
                <div className="confirmation-content">
                    <i className="pi pi-exclamation-triangle mr-3" style={{ fontSize: '2rem'}} />
                    {crew && <span>Are you sure you want to accept the selected crews?</span>}
                </div>
            </Dialog>

            <Dialog visible={deleteCrewDialog} style={{ width: '450px' }} header="Confirm" modal footer={deleteCrewDialogFooter} onHide={hideDeleteCrewDialog}>
                <div className="confirmation-content">
                    <i className="pi pi-exclamation-triangle mr-3" style={{ fontSize: '2rem'}} />
                    {crew && <span>Are you sure you want to delete <b>{crew.name}</b>?</span>}
                </div>
            </Dialog>

            <Dialog visible={deleteCrewsDialog} style={{ width: '450px' }} header="Confirm" modal footer={deleteCrewsDialogFooter} onHide={hideDeleteCrewsDialog}>
                <div className="confirmation-content">
                    <i className="pi pi-exclamation-triangle mr-3" style={{ fontSize: '2rem'}} />
                    {crew && <span>Are you sure you want to delete the selected crews?</span>}
                </div>
            </Dialog>
        </div>
    );
}

export default UnapprovedList;

