import React, { useRef } from 'react';
import { Menu } from 'primereact/menu';
import { Toast } from 'primereact/toast';
import 'primeicons/primeicons.css';
import 'primereact/resources/themes/lara-light-indigo/theme.css';
import 'primereact/resources/primereact.css';
import { useLocation, useNavigate, withRouter, useParams} from "react-router-dom";

// toast.current.show({ severity: 'success', summary: 'Updated', detail: 'Data Updated', life: 3000 });
const HelpMenu = () => {
    const menu = useRef(null);
    const toast = useRef(null);
    const navigate = useNavigate();

    const deneme = () => {
        console.log("passed");
    }

    const items = [
        {
            label: 'Cases',
            items: [
                {
                    label: 'New Cases',
                    icon: 'pi pi-refresh',
                    command: () => {
                        navigate('/detail', {state: 'active'});
                    }
                },
                {
                    label: 'Active Cases',
                    icon: 'pi pi-check',
                    command: () => {
                        toast.current.show({ severity: 'warn', summary: 'Delete', detail: 'Data Deleted', life: 3000 });
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
                    url: 'https://reactjs.org/'
                },
                {
                    label: 'Staff Management',
                    icon: 'pi pi-upload',
                    command:(e) => {
                        window.location.hash = "/fileupload"
                    }
                }
            ]
        }
    ];

    return (
        <div>
            <Toast ref={toast}></Toast>

            <div className="card" sx={{ width: 320, maxWidth: '100%' }}>
                <Menu model={items} style={{height: '300px', backgroundColor: "gray"}}/>
                <Menu model={items} popup ref={menu} id="popup_menu" />
            </div>
        </div>
    );
}
export default HelpMenu;