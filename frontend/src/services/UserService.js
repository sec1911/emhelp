import axios from "axios";
import AuthHeader from "./AuthHeader";

const API_URL = 'http://141.98.1.68:1000/users/';

class UserService{

    postUnitRegister(data){
        return axios
            .post(API_URL + 'account/unit-register',{
                email: data.email,
                password1: data.password,
                password2: data.rePassword,
                first_name: data.name,
                last_name: data.lastName,
                social_security_number: data.socialSecurityNumber,
                user_role: data.userRole,
                latitude: data.latitude,
                longitude: data.longitude,
                phone_number: data.phoneNumber
            })
    }

    getUnapprovedList(){
        return axios
            .get(API_URL + 'list-unapproved', {headers: AuthHeader()})
    }

    postApprovedUser(userId){
        return axios
            .post(API_URL + 'approve-unit/' + userId, '',{headers: AuthHeader()})
    }

    postRejectedUser(userId){
        return axios
            .post(API_URL + 'approve-unit/' + userId, {headers: AuthHeader()})
    }

    getAccountDetails(){
        return axios
            .get(API_URL + 'account/details', {headers: AuthHeader()})
    }

    getAllUnits(){
        return axios
            .get( API_URL + 'list-all-units', {headers: AuthHeader()})
    }

}

export default new UserService();