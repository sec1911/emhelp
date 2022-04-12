import './App.css';
import { Routes ,Route, Link } from 'react-router-dom';
import LoginPage from "./components/LoginPage";
import React, {useEffect, useState} from "react";
import SignInSide from "./components/SignInSide";
import Dashboard from "./components/Dashboard";
import Detail from "./components/Detail";
import Login from "./components/Login";
import Choice from "./components/Choice";
import CaseDetail from "./components/CaseDetail";
import AuthService from "./services/AuthService";
import MenuAppBar from "./components/MenuAppBar";
import Home from "./components/Home";
import IconMenu from "./components/IconMenu";


function App() {
    const [user, setUser] = useState(null) ;

    useEffect(() => {
        setUser(AuthService.getCurrentUser())
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

  return (

      <div className="container">
          { user ?
              (<Dashboard/>) : null
          }

        <div style={{marginTop:40,marginLeft:20,marginRight:20,color:"black"}}>
          <Routes>
              <Route exact path={"/"} element={<Choice/>} />
              <Route exact path={"/login"} element={<Login/>} />
              <Route exact path={"/home"} element={<Home/>} />
              <Route exact path={"/detail"} element={<Detail/>} />
              <Route exact path={"/case"} element={<CaseDetail/>} />
          </Routes>
        </div>
      </div>
  );
}

export default App;
