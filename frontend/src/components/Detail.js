import CaseTable from "./CaseTable";
import { useLocation } from "react-router-dom";
import React, { useState, useEffect  } from 'react';
import CaseService from "../services/CaseService";

const Detail = () => {
    const {state} = useLocation();
    const [activeCases, setActiveCases] = useState(null);
    const [closedCases, setClosedCases] = useState(null);

    useEffect(() => {
        CaseService.getActiveCases().then(
            (res) => {
                setActiveCases(res.data)
            }
        );

        CaseService.getClosedCases().then(
            (res) => {
                setClosedCases(res.data)
            }
        );

        document.body.style.backgroundColor = "pink"
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

    return (
        <div>
            <CaseTable dataset={state === 'active' ? activeCases : closedCases}/>
        </div>
    );
};

export default Detail;