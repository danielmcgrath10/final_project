import { Button } from "react-bootstrap";
import React, { useState } from "react";
import { Container, Form } from "react-bootstrap";
import "./login.scss";
import _ from "lodash";
import { api_login, create_user } from "../../api";

export default function Login(props) {

    const [createUser, setCreateUser] = useState(false);
    const [validated, setValidated] = useState(false);
    const [user, setUser] = useState({name: "", email: "", file: {},password: ""});

    const callApi = (type) => {
        if(type === "create"){
            let data = _.pick(user, ["name", "email", "file", "password"]);
            create_user(data);
        } else if (type === "login"){
            api_login(user.email, user.password);
        }
    }

    const handleSubmit = (e, type) => {
        const form = e.currentTarget;
        e.preventDefault();
        e.stopPropagation();
        if (form.checkValidity() === true) {
            callApi(type);
        }
        setValidated(true);
    };

    const update = (field, ev) => {
        let u1 = Object.assign({}, user);
        u1[field] = ev.target.value;
        setUser(u1);
    }

    const changePage = () => {
        setValidated(false);
        setUser({name: "", email: "", file: {},password: ""});
        setCreateUser(!createUser);
    }

    return(
        <Container style={{border: "1px solid lightgrey", borderRadius: "10px", padding: "20px", width: "30vw"}}>
            <h3>Welcome</h3>
            <h5>Please create an Account or Sign in to Continue!</h5>
            <hr/>
            {
                createUser ? 
                    <>
                        <Form noValidate validated={validated} onSubmit={(e) => handleSubmit(e, "create")} className={"login-form"}>
                            <Form.Group className={"login-group"}>
                                <Form.Label>
                                    Name
                                </Form.Label>
                                <Form.Control required type={"text"} placeholder={"Enter name"} value={user.name} onChange={(e) => update("name", e)}/>
                            </Form.Group>
                            <Form.Group className={"login-group"}>
                                <Form.Label>
                                    Email
                                </Form.Label>
                                <Form.Control required type={"email"} placeholder={"Enter email"} value={user.email} onChange={(e) => update("email", e)}/>
                            </Form.Group>
                            <Form.Group className={"login-group"}>
                                <Form.Label>
                                    Photo
                                </Form.Label>
                                <Form.File onChange={(e) => update("file", e)}/>
                            </Form.Group>
                            <Form.Group required className={"login-group"}>
                                <Form.Label>
                                    Password
                                </Form.Label>
                                <Form.Control required type={"password"} placeholder={"Password"} onChange={(e) => update("password", e)}/>
                            </Form.Group>
                            <Button
                                type={"submit"}
                            >
                                Create User
                            </Button>
                        </Form>
                        <br/>
                        <h5><a className={"login-switch"} onClick={changePage}>Login</a></h5>
                    </>
                :                    
                    <>
                        <Form noValidate validated={validated} className={"login-form"} onSubmit={(e) => handleSubmit(e, "login")} >
                            <Form.Group controlId={"formBasicEmail"} className={"login-group"}>
                            <Form.Label>Email</Form.Label>
                            <Form.Control
                                required
                                type="email"
                                placeholder="Enter Email"
                                value={user.email}
                                onChange={(ev) => update("email", ev)}
                            />
                            </Form.Group>
                            <Form.Group className={"login-group"}>
                            <Form.Label>Password</Form.Label>
                            <Form.Control
                                required
                                type="password"
                                placeholder="Password"
                                value={user.password}
                                onChange={(ev) => update("password", ev)}
                            />
                            </Form.Group>
                            <Button variant={"primary"} type="submit">
                            Login
                            </Button>
                        </Form>
                        <br/>
                        <h5><a className={"login-switch"} onClick={changePage}>Create User</a></h5>
                    </>
            }
        </Container>
    );
};