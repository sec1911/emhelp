import React, {useEffect} from 'react';
import { Button } from 'primereact/button';
import { useNavigate} from "react-router-dom";

const Choice = () => {
    const navigate = useNavigate();

    useEffect( () => {
        document.body.style.backgroundColor = "pink"
    }, []);

    const forwardLogin = () => {
        navigate('/login')
    }

    const registerUnit = () => {
        console.log("regisrter");
    }

    return (
        <div className="mb-2">
            <Button label="Register For Unit" className="p-button-success" onClick={registerUnit}/> &nbsp;&nbsp;&nbsp;
            <Button label="Sign In For Operator" className="p-button-help" onClick={forwardLogin}/>
        </div>
    );
};

export default Choice;