import React, {useEffect, useRef, useState} from "react";

import {MapContainer, Marker, Popup, TileLayer} from "react-leaflet";
import osm from "./osm-provider";
import "leaflet/dist/leaflet.css";
import L from "leaflet";
import UserService from "../services/UserService";
import Routing from "./Routing";
import {Button} from "primereact/button";
import CaseService from "../services/CaseService";

function createIcon() {
    return new L.Icon({
        iconUrl: require("../resources/check-mark.png"),
        iconSize: [40, 40]
    });
}

function dummyIcon(url) {
    if ( url === 'case'){
        return new L.Icon({
            iconUrl: require("../resources/marker.png"),
            iconSize: [40, 40]
        });
    }else if( url === 'police'){
        return new L.Icon({
            iconUrl: require("../resources/policeman.png"),
            iconSize: [40, 40]
        });
    }else if ( url === 'medic'){
        return new L.Icon({
            iconUrl: require("../resources/doctor.png"),
            iconSize: [40, 40]
        });
    }else{
        return new L.Icon({
            iconUrl: require("../resources/firefighter.png"),
            iconSize: [40, 40]
        });
    }
}


/*
<Marker
    position={center}
    icon={markerIcon}>
    <Popup>
        <b>Help!!!!</b>
    </Popup>
    icon={member.unit.user_role === 'case' ? markerIcon :
                                            member.unit.user_role === 'police' ? policeIcon :
                                            member.unit.user_role === 'firefighter' ? fireFighterIcon: mediceIcon
                                    }
</Marker>*/

const markerIcon = new L.Icon({
    iconUrl: require("../resources/marker.png"),
    iconSize: [40, 40]
});

const policeIcon = new L.Icon({
    iconUrl: require("../resources/policeman.png"),
    iconSize: [40, 40],
    fillColor: "#7FC9FF"
});

function mediceIcon (){
    return new L.Icon({
        iconUrl: require("../resources/doctor.png"),
        iconSize: [40, 40]
    });
}

const fireFighterIcon = new L.Icon({
    iconUrl: require("../resources/firefighter.png"),
    iconSize: [40, 40]
});

const CaseMap = ({caseId, long, lt, setValue}) => {
    const [center, setCenter] = useState({ lat: lt, lng: long });
    const ZOOM_LEVEL = 11;
    const mapRef = useRef();
    const [unitList, setUnitList] = useState([]);
    //const [selectedUnits, setSelectedUnits] = useState('');
    const [sources, setSources] = useState({lat: 39.9257770000000000, lng: 32.8660010000000000});
    const [units, setUnits] = useState([
        {
            "unit": {
                "email": "victim@emhelp.com",
                "first_name": "Victim",
                "last_name": "Emhelp",
                "user_role": "case",
                "phone_number": "5554444444"
            },
            "longitude": long,
            "latitude": lt
        }
    ]);
    const [selectedIndex, setSelectedIndex] = useState(-1);

    function handleClick(uid) {
        console.log("ffsfd"+uid)
        setSelectedIndex(uid)
    }

    function getMarkerIcon(index, role) {
        if(unitList.includes(index))
            return createIcon();
        return dummyIcon(role)
    }

    useEffect(() => {
        UserService.getAllUnits().then(
            (res) => {
                let arr = res.data;
                for( let i =0; i < arr.length; i++){
                    setUnits((un) => [...un, arr[i]])
                }
            }
        );
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

    const handlePopupClose = (e) => {
        e.preventDefault();
        console.log(e.popup)
    }

    function getIconType  (unitName)  {
        if ( unitName === "case"){
            console.log("hereeee")

        }else if ( unitName === "policeman"){

        }
    }

    const concatUnits = (uid) => {
        if ( unitList.includes(uid)){
            setUnitList(unitList.filter(item => item !== uid))
        }else{
            setUnitList( (unit) => [...unit, uid]);
        }

    }

    const submit = () => {
        let unitIds = unitList.join(',')
        console.log(unitIds);
        setValue(true)
        //CaseService.sendUnits(caseId, unitIds).then()
    }

    return (
        <>
            <div className="row">

                <div className="col text-center">
                    <h2>Victim and Units Locations</h2>
                    <div className="col">
                        <MapContainer center={center} zoom={ZOOM_LEVEL} ref={mapRef} onPopupClose={handlePopupClose}>
                            <TileLayer
                                url={osm.maptiler.url}
                                attribution={osm.maptiler.attribution}
                            />
                            {units.map((member, index) => (
                                <Marker
                                    position={[member.latitude, member.longitude]}
                                    onMouseOver={(e) => {
                                        e.target.openPopup();
                                    }}
                                    onMouseOut={(e) => {
                                        e.target.closePopup();
                                    }}

                                    key={index}
                                    index={index}
                                    eventHandlers={{
                                        click: (e) => {
                                            console.log('marker clicked', e)
                                            setSources(e.latLng)
                                            concatUnits(member.unit.id)
                                        },
                                    }}
                                    icon={getMarkerIcon(member.unit.id, member.unit.user_role)}

                                >
                                    <Popup>
                                        <div>
                                            {member.unit.first_name}, {member.unit.last_name}, {member.unit.user_role}
                                        </div>
                                    </Popup>
                                </Marker>
                            ))}

                        </MapContainer>
                    </div>
                </div>
                <Button style={{marginBottom: '15px', backgroundColor: 'green' }} onClick={submit}>Forward Crew</Button>
            </div>
        </>
    );
};

export default CaseMap;