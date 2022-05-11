import React, {useState} from 'react';
import {useLocation, useNavigate} from "react-router-dom";
import VoiceRecord from "./VoiceRecord";
import Box from '@mui/material/Box';
import { Card } from 'primereact/card';
import EventNoteIcon from '@mui/icons-material/EventNote';
import PersonIcon from '@mui/icons-material/Person';
import MessageIcon from '@mui/icons-material/Message';
import LocalPoliceIcon from '@mui/icons-material/LocalPolice';
import AnnouncementIcon from '@mui/icons-material/Announcement';
import CaseMap from "./CaseMap";
import Dashboard from "./Dashboard";
import {Button} from "primereact/button";
import {Dialog} from "primereact/dialog";


const CaseDetail = () => {
    const {state} = useLocation();
    const [showMessage, setShowMessage] = useState(false);
    const navigate = useNavigate();
    console.log(state)
    const url = 'http://141.98.1.68:1000' + state.caseDescription.voice_recording;

    function setParentValue(value){
        setShowMessage(value)
    }

    const forwardTable = () => {
        setShowMessage(false)
        navigate('/detail', {state: 'active'});
    }

    const dialogFooter = <div className="flex justify-content-center"><Button label="OK" className="p-button-text" autoFocus onClick={() => forwardTable()} /></div>;


    return (
        <div>
            <Dashboard/>
            <div style={{ height: '400px', width: '70%', display: 'flex', justifyContent: 'space-between', alignItems: 'center'}}>
                <Dialog visible={showMessage} onHide={() => setShowMessage(false)} position="top" footer={dialogFooter} showHeader={false} breakpoints={{ '960px': '80vw' }} style={{ width: '30vw' }}>
                    <div className="flex align-items-center flex-column pt-6 px-3">
                        <i className="pi pi-check-circle" style={{ fontSize: '5rem', color: 'var(--green-500)' }}></i>
                        <h5>Unit Selection Successful!</h5>
                        <p style={{ lineHeight: 1.5, textIndent: '1rem' }}>
                            Units are selected successfully. Go to the Case Page
                        </p>
                    </div>
                </Dialog>
                <Card title="Victim"  style={{ marginTop:"70px", width: '25em' , marginLeft: '200px', borderRadius: "50px", backgroundColor: '#FF6384'}}  >
                    <p className="p-m-0" style={{lineHeight: '2.0'}}>
                        <PersonIcon/> {state.caseDescription.opened_by.name}
                    </p>
                    <p className="p-m-0" style={{lineHeight: '1.0'}}>
                        <MessageIcon/> {state.caseDescription.message}
                    </p>
                    <Box sx={{ display: 'flex', alignItems: 'center', pl: 1, pb: 1 }}>
                        <VoiceRecord url={url}/>
                    </Box>
                </Card>
                <Card title="Unit Request" style={{ marginTop:"70px",width: '25em', marginRight: '-200px', borderRadius: "50px", backgroundColor: '#FFCE56'}}  >
                    <p className="p-m-0" style={{lineHeight: '2.5'}}>
                        <EventNoteIcon/> {state.caseDescription.date_created}
                    </p>
                    <p className="p-m-0" style={{lineHeight: '1.5'}}>
                        <LocalPoliceIcon/> {state.caseDescription.unit_type}
                    </p>
                    <p className="p-m-0" style={{lineHeight: '1.5'}}>
                        <AnnouncementIcon/> {state.caseDescription.incident_type}
                    </p>

                </Card>
            </div>
            <div style={{ height: '600px', width: '100%'}}>
                <CaseMap caseId={state.caseDescription.id} long={state.caseDescription.longitude} lt={state.caseDescription.latitude} setValue={setParentValue}/>
            </div>
        </div>

    )
};

export default CaseDetail;