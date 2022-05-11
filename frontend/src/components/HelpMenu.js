import React, { useRef } from 'react';
import { Menu } from 'primereact/menu';
import { Toast } from 'primereact/toast';
import 'primeicons/primeicons.css';
import 'primereact/resources/themes/lara-light-indigo/theme.css';
import 'primereact/resources/primereact.css';
import {useNavigate} from "react-router-dom";

const HelpMenu = () => {
    const menu = useRef(null);
    const toast = useRef(null);
    const navigate = useNavigate();

    const items = [
        {
            label: 'Cases',
            items: [
                {
                    label: 'Active Cases',
                    icon: 'pi pi-refresh',
                    command: () => {
                        navigate('/detail', {state: 'active'});
                    }
                },
                {
                    label: 'Closed Cases',
                    icon: 'pi pi-times',
                    command: () => {
                        toast.current.show({ severity: 'warn', summary: 'Delete', detail: 'Data Deleted', life: 3000 });
                        navigate('/detail', {state: 'inactive'});
                    }
                }

            ]
        },
        {
            label: 'Navigate',
            items: [
                {
                    label: 'Forward to Home',
                    icon: 'pi pi-external-link',
                    url: 'https://www.112.gov.tr/'
                },
                {
                    label: 'Staff Management',
                    icon: 'pi pi-user-plus',
                    command:(e) => {
                        navigate('/user-list');
                    }
                }
            ]
        }
    ];

    return (
        <div>
            <Toast ref={toast}></Toast>

            <div className="card" >
                <Menu model={items} style={{marginLeft: -20, height: '720px', width: 245, backgroundColor: '#cdb4ce'}}/>
                <Menu model={items} popup ref={menu} id="popup_menu" />
            </div>
        </div>
    );
}
export default HelpMenu;