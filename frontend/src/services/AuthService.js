import axios from "axios";

const API_URL = 'http://141.98.1.68:1000/';

class AuthService {
    login(username, password) {
        return axios
            .post(API_URL + "users/account/login/", {
                email:username,
                password:password
            })
            .then(response => {
                localStorage.setItem("user", JSON.stringify(response.data));

                return response.data;
            });
    }

    logout() {
        localStorage.removeItem("user");
    }

    getCurrentUser() {
        return JSON.parse(localStorage.getItem('user'));;
    }
}

export default new AuthService();