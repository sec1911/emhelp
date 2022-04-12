import React from 'react';
import { useLocation } from "react-router-dom";
import SimpleMap from "./SimpleMap";
import VoiceRecord from "./VoiceRecord";
import Box from '@mui/material/Box';
import CardContent from '@mui/material/CardContent';
import Typography from '@mui/material/Typography';
import { Card } from 'primereact/card';
import EventNoteIcon from '@mui/icons-material/EventNote';
import PersonIcon from '@mui/icons-material/Person';
import MessageIcon from '@mui/icons-material/Message';
import LocalPoliceIcon from '@mui/icons-material/LocalPolice';
import AnnouncementIcon from '@mui/icons-material/Announcement';

//<SimpleMap long={32.87856246948242} lat={39.95999958185722}/>
const CaseDetail = () => {
    const {state} = useLocation();
    console.log(state)
    const url = 'http://141.98.1.68:1000' + state.caseDescription.voice_recording;

//<SimpleMap long={state.caseDescription.longitude} lat={state.caseDescription.latitude}/>
    return (
        <div style={{ height: '400px', width: '70%', display: 'flex', justifyContent: 'space-between', alignItems: 'center'}}>
            <Card title="Victim"  style={{ width: '22em' , marginLeft: '200px', borderRadius: "50px"}}  >
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
            <Card title="Unit" style={{ width: '22em', marginRight: '-200px', borderRadius: "50px"}}  >
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

    )
};

export default CaseDetail;