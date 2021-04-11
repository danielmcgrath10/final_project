import React, { useState } from "react";
import "./drink-modal.scss";
import { Box, FormGroup, TextField, Typography } from "@material-ui/core";
import Rating from "@material-ui/lab/Rating";
import { Modal, Form, InputGroup, Button, Spinner } from "react-bootstrap";
import { LocalBar, LocalDrink } from "@material-ui/icons";
import { NotificationManager } from "react-notifications";
import _ from "lodash";
import { create_post, get_location } from "../../api";

// Portions are inspired by the course notes
export default function DrinkModal(props){
    const {
        modalOpen,
        setModalOpen,
        session
    } = props;
    const [postFormValidated, setPostValidated] = useState(false);
    const [loading, setLoading] = useState(false);
    const [locLoading, setLocLoading] = useState(false);

    const [event, setEvent] = useState({
        caption: "",
        drinkName: "",
        location: "",
        rating: 0,
    });

    const onHide = () => {
        setEvent({
            caption: "",
            drinkName: "",
            location: "",
            rating: 0,
        });
        setPostValidated(false);
        setModalOpen(false);
    }

    const createPost = () => {
        let data = _.pick(event, ["caption", "drinkName", "location", "rating", "timestamp"]);
        create_post(data, session)
        .then(() => {
            onHide();
        });
    }

    const update = (field, e) => {
        let u1 = Object.assign({}, event);
        u1[field] = e.target.value;
        setEvent(u1);
    }

    const handlePostSubmit = (e) => {
        const form = e.currentTarget;
        e.preventDefault();
        e.stopPropagation();

        if(form.checkValidity() === true){
            createPost();
        }

        setPostValidated(true);
    }

    const handleCurLocation = () => {
        if(navigator.geolocation) {
            setLocLoading(true);
            navigator.geolocation.getCurrentPosition(setPosition);
            return;
        } else {
            return
        }
    }

    const setPosition = (position) => {
        let lat = position.coords.latitude;
        let lon = position.coords.longitude;
        get_location(lat, lon)
        .then((data) => {
            if(data && data["results"] && !_.isEmpty(data.results)){
                let u1 = Object.assign({}, event);
                u1["location"] = data.results[0].formatted_address;
                setEvent(u1);
            }
            setLocLoading(false);
        })
        .catch((err) => {
            NotificationManager.error("Error", err);
        });
    }

    return(
        <Modal show={modalOpen} onHide={onHide} centered>
            <Modal.Header closeButton>
                <Modal.Title>New Drink Excursion</Modal.Title>
            </Modal.Header>
            <Modal.Body id={"post-modal"}>
                {
                    loading ? 
                        <Spinner animation={"border"} />
                    :
                        <Form
                            noValidate
                            validated={postFormValidated}
                            onSubmit={handlePostSubmit}
                        >
                            <Form.Group>
                                <InputGroup >
                                    {
                                        locLoading ?
                                            <Spinner animation={"border"}/>
                                        :
                                        <Button
                                            variant={"secondary"}
                                            onClick={handleCurLocation}
                                        >
                                            Current Location
                                        </Button>
                                    }  
                                    <Form.Control required placeholder={"Venue Name"} className={"activity-modal-input"} value={event.location} onChange={(e) => update("location", e)}/>
                                </InputGroup>
                            </Form.Group>
                            <Form.Group id={"text-input"} >
                                <TextField required id={"outlined-basic"} label={"Drink"} variant={"outlined"} value={event.drinkName} onChange={(e) => update("drinkName", e)} />
                            </Form.Group>
                            <Form.Group>
                                <Box>
                                    <Typography component={"legend"}>Rating</Typography>
                                    <Rating 
                                        name={"Rating"}
                                        size={"large"}
                                        icon={<LocalBar fontSize={"inherit"} />}
                                        value={Number(event.rating)}
                                        onChange={(e) => update("rating", e)}
                                    />
                                </Box>
                            </Form.Group>
                            <Form.Group>
                                <Form.Control as={"textarea"} rows={3} placeholder={"Caption"} value={event.caption} onChange={(e) => update("caption", e)} />
                            </Form.Group>
                            <Button
                                type={"submit"}
                                variant={"primary"}
                            >
                                Create
                            </Button>
                        </Form>
                }
            </Modal.Body>
        </Modal>
    )
}