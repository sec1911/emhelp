import React, {useEffect, useState} from 'react';
import HelpMenu from "./HelpMenu";
import UserService from "../services/UserService";
import { Card } from 'primereact/card';
import CaseChart from "./CaseChart";
import Dashboard from "./Dashboard";

const Home = () => {
    const [userInfo, setUserInfo] = useState('');

    useEffect(() => {

        UserService.getAccountDetails().then(
            (res) => {
                setUserInfo(res.data)
            }
        )
        document.body.style.backgroundColor = "#e3e3d1"
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

    return (

        <div style={{marginTop: 60, display:'flex', flexDirection:'row'}}>
            <Dashboard/>
            <div style={{marginLeft: 0}}>
                <HelpMenu/>
            </div>
            <h3 style={{marginLeft: 40, width: 300}}>Welcome back,{userInfo.first_name}</h3>
            <CaseChart/>
            <Card title="Total Cases" style={{ marginTop: 350, marginLeft: -700, width: '20rem', height: 250, backgroundColor: '#FFCE56'}}>
                <h1>5</h1>
            </Card>
            <Card title="New Cases" style={{ marginTop: 350, marginLeft: 50, width: '20rem', height: 250, backgroundColor: '#FF6384'}}>
                <h1>3</h1>
            </Card>
            <Card title="Active Cases" style={{ marginTop: 350, marginLeft: 50, width: '20rem', height: 250, backgroundColor: '#36A2EB'}}>
                <h1>1</h1>
            </Card>
            <Card title="Closed Cases" style={{ marginTop: 350, marginLeft: 50, marginRight: 25, width: '20rem', height: 250, backgroundColor: '#0ce378'}}>
                <h1>1</h1>
            </Card>

        </div>

    );
};

export default Home;