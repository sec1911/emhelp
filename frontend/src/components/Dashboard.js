import React, {useState} from 'react';
import MenuAppBar from "./MenuAppBar";
import HelpMenu from "./HelpMenu";


// { user ?
//             (<MenuAppBar stateChanger={setShowMenu}/>) : null
//             }
// {showMenu ? <HelpMenu/> : null}
const Dashboard = () => {
    const[showMenu, setShowMenu] = useState(false);

    return (
        <div>
            <div>
                <MenuAppBar stateChanger={setShowMenu}/>
            </div>
        </div>
    );
};

export default Dashboard;