
import AuthHeader from "../services/AuthHeader";
import React from "react";

export default function RequireAuth({ children }) {
    const authed = AuthHeader();

    return authed.Authorization ? children : <h1>Forbidden</h1>;
}