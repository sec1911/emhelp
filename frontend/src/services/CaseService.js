import axios from "axios";
import AuthHeader from "./AuthHeader";

const API_URL = 'http://141.98.1.68:1000/';

class CaseService{
    getActiveCases(){
        return axios
            .get(API_URL + 'emergencies/list-active', {headers: AuthHeader()})
    }

    getClosedCases(){
        return axios
            .get(API_URL + 'emergencies/list-inactive', {headers: AuthHeader()})
    }

}

export default new CaseService();