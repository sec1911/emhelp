import React from 'react';
import { Howl } from "howler";
import { Button } from 'primereact/button';

const VoiceRecord = ({url}) => {

    const sound = new Howl({
        src: [url],
        html5: true,
        format: ['mp3', 'aac']
    });

    return (
        <div>
            <Button style={{marginLeft: 90}} onClick={ () => sound.play()} type="button" icon="pi pi-play"/>
            <Button style={{marginLeft: 25}} onClick={ () => sound.pause()} type="button" icon="pi pi-pause"/>
        </div>
    );
};

export default VoiceRecord;