import './App.css';
import { Routes ,Route} from 'react-router-dom';
import React, {useEffect, useState} from "react";
import Detail from "./components/Detail";
import Login from "./components/Login";
import Choice from "./components/Choice";
import CaseDetail from "./components/CaseDetail";
import AuthService from "./services/AuthService";
import Home from "./components/Home";
import Register from "./components/Register";
import UnapprovedList from "./components/UnapprovedList";
import RequireAuth from "./components/RequiredAuth";

function App() {
    const [user, setUser] = useState('') ;

    useEffect(() => {
        setUser(AuthService.getCurrentUser())
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

  return (

      <div className="container">

        <div>
                <Routes>
                    <Route exact path={"/"} element={<Choice/>} />
                    <Route exact path={"/login"} element={<Login/>} />
                    <Route exact path={"/home"} element={<RequireAuth> <Home/> </RequireAuth> } />
                    <Route exact path={"/detail"} element={<RequireAuth> <Detail/> </RequireAuth>} />
                    <Route exact path={"/case"} element={<RequireAuth> <CaseDetail/> </RequireAuth>} />
                    <Route exact path={"/register"} element={<Register/>} />
                    <Route path="/user-list" element={<RequireAuth> <UnapprovedList/> </RequireAuth>} />
                </Routes>

        </div>
      </div>
  );
}

export default App;
