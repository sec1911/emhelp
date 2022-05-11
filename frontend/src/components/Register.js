import 'primeicons/primeicons.css';
import 'primereact/resources/themes/lara-light-indigo/theme.css';
import 'primereact/resources/primereact.css';
import 'primeflex/primeflex.css';
import '../index.css';

import React, { useEffect, useState } from 'react';
import { useFormik } from 'formik';
import { InputText } from 'primereact/inputtext';
import { Button } from 'primereact/button';
import { Dropdown } from 'primereact/dropdown';
import { Calendar } from 'primereact/calendar';
import { Password } from 'primereact/password';
import { Checkbox } from 'primereact/checkbox';
import { Dialog } from 'primereact/dialog';
import { Divider } from 'primereact/divider';
import { classNames } from 'primereact/utils';
import '../design/FormDemo.css'
import RegisterMap from "./RegisterMap";
import UserService from "../services/UserService";
import emHelpImage from "../resources/emhelpbackground.jpeg";

export const Register = () => {
    const [showMessage, setShowMessage] = useState(false);
    const [formData, setFormData] = useState({});
    const [userRole, setUserRole] = useState(['operator','firefighter', 'medic', 'police']);
    const [selectedPosition, setSelectedPosition] = useState([0,0]);
    const [message, setMessage] = useState('');
    const [valid, setValid] = useState(false);

    useEffect(() => {
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

    const formik = useFormik({
        initialValues: {
            socialSecurityNumber: '',
            name: '',
            lastName: '',
            email: '',
            password: '',
            telephoneNumber: '',
            rePassword: null,
            userRole: null,
            latitude: 39.871538,
            longitude: 32.737337,
            accept: false
        },
        validate: (data) => {
            let errors = {};

            if (!data.socialSecurityNumber) {
                errors.socialSecurityNumber = 'Social Security Number is required.';
            }

            if (!data.name) {
                errors.name = 'Name is required.';
            }

            if (!data.lastName) {
                errors.lastName = 'Last Name is required.';
            }

            if (!data.email) {
                errors.email = 'Email is required.';
            }
            else if (!/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.test(data.email)) {
                errors.email = 'Invalid email address. E.g. example@email.com';
            }

            if (!data.password) {
                errors.password = 'Password is required.';
            }

            if (!data.rePassword){
                errors.rePassword = 'RePassword is required';
            }

            if (!data.userRole) {
                errors.userRole = 'User Role is required.';
            }

            if (!data.telephoneNumber) {
                errors.telephoneNumber = 'Telephone Number is required.';
            }

            if (!data.accept) {
                errors.accept = 'You need to agree to the terms and conditions.';
            }

            return errors;
        },
        onSubmit: (data) => {
            setFormData(data);

            console.log(data)
            UserService.postUnitRegister(data).then(r => {
                setShowMessage(true);
                formik.resetForm();
                setValid(true);
            },
                error => {
                    const resMessage =
                        (error.response &&
                            error.response.data &&
                            error.response.data.message) ||
                        error.message ||
                        error.toString();

                    console.log(error.response.data)
                    setMessage(error.response.data);
                }
            );

        }
    });

    const isFormFieldValid = (name) => !!(formik.touched[name] && formik.errors[name]);
    const getFormErrorMessage = (name) => {
        return isFormFieldValid(name) && <small className="p-error">{formik.errors[name]}</small>;
    };

    const dialogFooter = <div className="flex justify-content-center"><Button label="OK" className="p-button-text" autoFocus onClick={() => setShowMessage(false)} /></div>;
    const passwordHeader = <h6>Pick a password</h6>;
    const passwordFooter = (
        <React.Fragment>
            <Divider />
            <p className="mt-2">Suggestions</p>
            <ul className="pl-2 ml-2 mt-0" style={{ lineHeight: '1.5' }}>
                <li>At least one lowercase</li>
                <li>At least one uppercase</li>
                <li>At least one numeric</li>
                <li>Minimum 8 characters</li>
            </ul>
        </React.Fragment>
    );

    return (
        <div className="form-demo" style={{backgroundImage: `url(${emHelpImage})`}}>
            <Dialog visible={showMessage} onHide={() => setShowMessage(false)} position="top" footer={dialogFooter} showHeader={false} breakpoints={{ '960px': '80vw' }} style={{ width: '30vw' }}>
                <div className="flex align-items-center flex-column pt-6 px-3">
                    <i className="pi pi-check-circle" style={{ fontSize: '5rem', color: 'var(--green-500)' }}></i>
                    <h5>Registration Successful!</h5>
                    <p style={{ lineHeight: 1.5, textIndent: '1rem' }}>
                        Your account is registered under name <b>{formData.name}</b> ; it'll be valid next 30 days without activation. Please check <b>{formData.email}</b> for activation instructions.
                    </p>
                </div>
            </Dialog>

            <div style={{ marginLeft: '300px',display:'flex', flexDirection:'row'}}>
                <div className="card">
                    <h5 className="text-center">Register</h5>
                    <form onSubmit={formik.handleSubmit} className="p-fluid">
                        <div className="field">
                            <span className="p-float-label">
                                <InputText id="socialSecurityNumber" name="socialSecurityNumber" value={formik.values.socialSecurityNumber} onChange={formik.handleChange} autoFocus className={classNames({ 'p-invalid': isFormFieldValid('socialSecurityNumber') })} />
                                <label htmlFor="socialSecurityNumber" className={classNames({ 'p-error': isFormFieldValid('socialSecurityNumber') })}>Social Security Number*</label>
                            </span>
                            {getFormErrorMessage('socialSecurityNumber')}
                            {message && (
                                <div className="form-group">
                                    <div className="alert alert-danger" role="alert">
                                        {message.social_security_number}
                                    </div>
                                </div>
                            )}
                        </div>
                        <div className="field">
                            <span className="p-float-label">
                                <InputText id="name" name="name" value={formik.values.name} onChange={formik.handleChange} autoFocus className={classNames({ 'p-invalid': isFormFieldValid('name') })} />
                                <label htmlFor="name" className={classNames({ 'p-error': isFormFieldValid('name') })}>Name*</label>
                            </span>
                            {getFormErrorMessage('name')}
                            {message && (
                                <div className="form-group">
                                    <div className="alert alert-danger" role="alert">
                                        {message.name}
                                    </div>
                                </div>
                            )}
                        </div>
                        <div className="field">
                            <span className="p-float-label">
                                <InputText id="lastName" name="lastName" value={formik.values.lastName} onChange={formik.handleChange} autoFocus className={classNames({ 'p-invalid': isFormFieldValid('lastName') })} />
                                <label htmlFor="lastName" className={classNames({ 'p-error': isFormFieldValid('lastName') })}>Last Name*</label>
                            </span>
                            {getFormErrorMessage('lastName')}
                            {message && (
                                <div className="form-group">
                                    <div className="alert alert-danger" role="alert">
                                        {message.last_name}
                                    </div>
                                </div>
                            )}
                        </div>
                        <div className="field">
                            <span className="p-float-label p-input-icon-right">
                                <i className="pi pi-envelope" />
                                <InputText id="email" name="email" value={formik.values.email} onChange={formik.handleChange} className={classNames({ 'p-invalid': isFormFieldValid('email') })} />
                                <label htmlFor="email" className={classNames({ 'p-error': isFormFieldValid('email') })}>Email*</label>
                            </span>
                            {getFormErrorMessage('email')}
                            {message && (
                                <div className="form-group">
                                    <div className="alert alert-danger" role="alert">
                                        {message.email}
                                    </div>
                                </div>
                            )}
                        </div>
                        <div className="field">
                            <span className="p-float-label">
                                <Password id="password" name="password" value={formik.values.password} onChange={formik.handleChange} toggleMask
                                          className={classNames({ 'p-invalid': isFormFieldValid('password') })} header={passwordHeader} footer={passwordFooter} />
                                <label htmlFor="password" className={classNames({ 'p-error': isFormFieldValid('password') })}>Password*</label>
                            </span>
                            {getFormErrorMessage('password')}
                            {message && (
                                <div className="form-group">
                                    <div className="alert alert-danger" role="alert">
                                        {message.password1}
                                    </div>
                                </div>
                            )}
                        </div>
                        <div className="field">
                            <span className="p-float-label">
                                <Password id="rePassword" name="rePassword" value={formik.values.rePassword} onChange={formik.handleChange} toggleMask
                                          className={classNames({ 'p-invalid': isFormFieldValid('rePassword') })} />
                                <label htmlFor="rePassword" className={classNames({ 'p-error': isFormFieldValid('rePassword') })}>ReEnter Password*</label>
                            </span>
                            {getFormErrorMessage('rePassword')}
                            {message && (
                                <div className="form-group">
                                    <div className="alert alert-danger" role="alert">
                                        {message.password2}
                                    </div>
                                </div>
                            )}
                        </div>
                        <div className="field">
                            <span className="p-float-label">
                                <InputText id="telephoneNumber" name="telephoneNumber" value={formik.values.telephoneNumber} onChange={formik.handleChange} autoFocus className={classNames({ 'p-invalid': isFormFieldValid('telephoneNumber') })} />
                                <label htmlFor="telephoneNumber" className={classNames({ 'p-error': isFormFieldValid('telephoneNumber') })}>Telephone Number*</label>
                            </span>
                            {getFormErrorMessage('telephoneNumber')}
                            {message && (
                                <div className="form-group">
                                    <div className="alert alert-danger" role="alert">
                                        {message.phone_number}
                                    </div>
                                </div>
                            )}
                        </div>

                        <div className="field">
                            <span className="p-float-label">
                                <Dropdown id="userRole" name="userRole" value={formik.values.userRole} onChange={formik.handleChange} options={userRole}  />
                                <label htmlFor="userRole">User Role*</label>
                            </span>
                        </div>
                        <div className="field-checkbox">
                            <Checkbox inputId="accept" name="accept" checked={formik.values.accept} onChange={formik.handleChange} className={classNames({ 'p-invalid': isFormFieldValid('accept') })} />
                            <label htmlFor="accept" className={classNames({ 'p-error': isFormFieldValid('accept') })}>I agree to the terms and conditions*</label>
                        </div>
                        <Button type="submit" label="Submit" className="mt-2" />
                    </form>
                </div>
                <RegisterMap/>
            </div>

        </div>
    );
}

export default Register;