import React, {useEffect} from 'react';
import { Button } from 'primereact/button';
import { useNavigate} from "react-router-dom";
import emHelpImage from "../resources/emhelpbackground.jpeg";

const Choice = () => {
    const navigate = useNavigate();

    useEffect( () => {
        //document.body.style.backgroundColor = "pink"

    }, []);

    const forwardLogin = () => {
        navigate('/login')
    }

    const registerUnit = () => {
        navigate('/register')
    }

    return (
        <div className="choice" style={{backgroundImage: `url(${emHelpImage})`}}>
            <div className="mb-2" >
                <Button style={{marginLeft: '0px' }} label="Register For Unit" className="p-button-success" onClick={registerUnit}/>
                <Button style={{marginLeft: '20px'}} label="Sign In For Operator" className="p-button-help" onClick={forwardLogin}/>
            </div>
        </div>


    );
};

export default Choice;