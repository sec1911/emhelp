import axios from "axios";
import AuthHeader from "./AuthHeader";

const API_URL = 'http://141.98.1.68:1000/users/';

class UserService{
    getUnapprovedList(){
        return axios
            .get(API_URL + 'list-unapproved', {headers: AuthHeader()})
    }

}

export default new UserService();