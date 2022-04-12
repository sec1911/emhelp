import React, {useState} from 'react';
import MenuAppBar from "./MenuAppBar";
import HelpMenu from "./HelpMenu";
import AuthService from "../services/AuthService";
import IconMenu from "./IconMenu";

// { user ?
//             (<MenuAppBar stateChanger={setShowMenu}/>) : null
//             }
// {showMenu ? <HelpMenu/> : null}
const Dashboard = () => {
    const[showMenu, setShowMenu] = useState(false);
    const user = AuthService.getCurrentUser();

    return (
        <div>
            <div>
                <MenuAppBar/>
            </div>
            <div style={{marginTop: 60, flex: 'auto', overflow: 'auto'}}>
                <HelpMenu/>
            </div>

        </div>
    );
};

export default Dashboard;