import React, {useEffect, useState} from 'react';
import Form from "react-validation/build/form";
import Input from "react-validation/build/input";
import AuthService from "../services/AuthService";
import {  useNavigate, BrowserRouter} from "react-router-dom";
import { Link } from "react-router-dom";
import emHelpImage from "../resources/emhelpbackground.jpeg";

const Login = () => {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const [loading, setLoading] = useState(false);
    const [message, setMessage] = useState("");

    useEffect( () => {

    }, []);

    const navigate = useNavigate();

    const required = value => {
        if (!value) {
            return (
                <div className="alert alert-danger" role="alert">
                    This field is required!
                </div>
            );
        }
    };

    const handleLogin = (e) =>{
        e.preventDefault();

        setLoading(true);

        //this.form.validateAll();
        if ( username !== "" && password !== ""){
            AuthService.login(username, password).then(
                () => {
                    navigate('/home');
                },
                error => {
                    const resMessage =
                        (error.response &&
                            error.response.data &&
                            error.response.data.message) ||
                        error.message ||
                        error.toString();

                    console.log(resMessage)
                    setLoading(false);
                    setMessage("Email or password is not correct!");
                }
            );
        }else{
            setLoading(false);
        }
    }

    return (
        <div className="loginBackground" style={{ backgroundImage: `url(${emHelpImage})`}}>

                <div className="card-card-container" >
                    <img
                        src="//ssl.gstatic.com/accounts/ui/avatar_2x.png"
                        alt="profile-img"
                        className="profile-img-card"
                    />

                    <Form
                        onSubmit={handleLogin}
                    >
                        <div className="form-group">
                            <label htmlFor="username">Username*</label>
                            <Input
                                type="text"
                                className="form-control"
                                name="username"
                                placeholder="Enter username"
                                value={username}
                                onChange={(e) => setUsername(e.target.value)}
                                validations={[required]}
                            />
                        </div>

                        <div className="form-group">
                            <label htmlFor="password">Password*</label>
                            <Input
                                type="password"
                                className="form-control"
                                name="password"
                                placeholder="Enter Password"
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                                validations={[required]}
                            />
                        </div>

                        <div className="form-group">
                            <button
                                style={{marginTop:10}}
                                className="button-group"
                                color="success"
                                disabled={loading}
                            >
                                {loading && (
                                    <span className="spinner-border spinner-border-sm"></span>
                                )}
                                <span>Login</span>
                            </button>
                        </div>

                        {message && (
                            <div className="form-group">
                                <div className="alert alert-danger" role="alert">
                                    {message}
                                </div>
                            </div>
                        )}

                    </Form>

                </div>

        </div>

    );
};

export default Login;