import * as React from 'react';
import AppBar from '@mui/material/AppBar';
import Box from '@mui/material/Box';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import IconButton from '@mui/material/IconButton';
import HomeIcon from '@mui/icons-material/Home';
import AccountCircle from '@mui/icons-material/AccountCircle';
import MenuItem from '@mui/material/MenuItem';
import Menu from '@mui/material/Menu';
import Logout from '@mui/icons-material/Logout';
import Avatar from '@mui/material/Avatar';
import NotificationsIcon from '@mui/icons-material/Notifications';
import AuthService from "../services/AuthService";
import { useNavigate} from "react-router-dom";

export default function MenuAppBar({stateChanger}) {
    const [auth, setAuth] = React.useState(true);
    const [anchorEl, setAnchorEl] = React.useState(null);
    const navigate = useNavigate();

    const handleChange = (event) => {
        setAuth(event.target.checked);
    };

    const handleMenu = (event) => {
        setAnchorEl(event.currentTarget);
    };

    const handleClose = () => {
        setAnchorEl(null);
    };

    const logOut = () => {
        AuthService.logout();
    }

    const forwardHomePage = () => {
        navigate('/home')
    }

    return (
        <Box sx={{ flexGrow: 1 }}>
            <AppBar position="fixed" color="secondary" sx={{ bgcolor: "#ba4f76" }}>
                <Toolbar>
                    <IconButton
                        size="large"
                        edge="start"
                        onClick={() => forwardHomePage()}
                        color="inherit"
                        aria-label="menu"
                        sx={{ mr: 2}}
                    >
                        <HomeIcon />
                    </IconButton>
                    <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
                    </Typography>
                    {auth && (
                        <div>
                            <IconButton>
                                <NotificationsIcon style={{color: "white"}}/>
                            </IconButton>
                            <IconButton
                                size="large"
                                aria-label="account of current user"
                                aria-controls="menu-appbar"
                                aria-haspopup="true"
                                onClick={handleMenu}
                                color="inherit"
                            >
                                <AccountCircle />
                            </IconButton>
                            <Menu
                                id="menu-appbar"
                                anchorEl={anchorEl}
                                anchorOrigin={{
                                    vertical: 'top',
                                    horizontal: 'right',
                                }}
                                keepMounted
                                transformOrigin={{
                                    vertical: 'top',
                                    horizontal: 'right',
                                }}
                                open={Boolean(anchorEl)}
                                onClose={handleClose}
                            >
                                <MenuItem onClick={handleClose}> <Avatar sx={{ marginRight: '10px', height: '25px', width: '25px' }} />  Profile</MenuItem>
                                <MenuItem component="a" href="/" onClick={logOut}> <Logout sx={{marginRight: '10px'}}/>Log Out</MenuItem>
                            </Menu>
                        </div>
                    )}
                </Toolbar>
            </AppBar>
        </Box>
    );
}