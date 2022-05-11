import React, { useState, useRef } from "react";

import {MapContainer, Marker, Popup, TileLayer, useMapEvents} from "react-leaflet";
import osm from "./osm-provider";
import "leaflet/dist/leaflet.css";
import L from "leaflet";
import {number} from "prop-types";


delete L.Icon.Default.prototype._getIconUrl;

L.Icon.Default.mergeOptions({
    iconRetinaUrl:
        "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.3.1/images/marker-icon.png",
    iconUrl:
        "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.3.1/images/marker-icon.png",
    shadowUrl:
        "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.3.1/images/marker-shadow.png",
});

const markerIcon = new L.Icon({
    iconUrl: require("../resources/marker.png"),
    iconSize: [40, 40]
});

const RegisterMap = () => {
    const [center, setCenter] = useState({ lat: 39.871538, lng: 32.737337 });
    const ZOOM_LEVEL = 9;
    const mapRef = useRef();
    const [selectedPosition, setSelectedPosition] = useState([0,0]);

    const Markers = () => {

        const map = useMapEvents({
            click(e) {
                console.log(e)
                setSelectedPosition([
                    e.latlng.lat,
                    e.latlng.lng
                ]);
            },
        })

        return (
            selectedPosition ?
                <Marker
                    key={selectedPosition[0]}
                    position={selectedPosition}
                    interactive={false}
                />
                : null
        )

    }

    const addMarker = (e) =>{
        console.log()
        /*
        {
                                marker ?
                                    <Marker
                                        position={{lat: marker.lat, lng: marker.lng}}
                                        icon={markerIcon}
                                        key={marker.time.toISOString()}
                                    >
                                    </Marker> : null
                            }

        (event) => {
                                 setMarker(  {
                                     lat: event.latLng.lat(),
                                     lng: event.latLng.lng(),
                                     time: new Date()
                                 })
                             }
         */
    }

    return (
        <>

            <div className="row" style={{marginLeft: '130px'}}>
                <div className="col text-center">
                    <h2>Select your location from the below map</h2>
                    <div className="col">
                        <MapContainer center={center} zoom={ZOOM_LEVEL} ref={mapRef}
                             onClick={addMarker}>
                            <TileLayer
                                url={osm.maptiler.url}
                                attribution={osm.maptiler.attribution}
                            />

                        <Markers/>
                        </MapContainer>
                    </div>
                </div>
            </div>
        </>
    );
};
export default RegisterMap;