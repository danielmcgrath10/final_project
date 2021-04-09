import React, { useState } from "react";
import "./drink-modal.scss";
import { Box, FormGroup, TextField, Typography } from "@material-ui/core";
import Rating from "@material-ui/lab/Rating";
import { Modal, Form, InputGroup, Button, Spinner } from "react-bootstrap";
import { LocalBar, LocalDrink } from "@material-ui/icons";
import { NotificationManager } from "react-notifications";
import _ from "lodash";
import { create_post } from "../../api";

export default function DrinkModal(props){
    const {
        modalOpen,
        setModalOpen,
        session
    } = props;
    const [postFormValidated, setPostValidated] = useState(false);
    const [loading, setLoading] = useState(false);

    const [event, setEvent] = useState({
        caption: "",
        drinkName: "",
        lat: 0,
        lon: 0,
        name: "",
        rating: 0,
    });

    const onHide = () => {
        setEvent({
            caption: "",
            drinkName: "",
            lat: 0,
            lon: 0,
            name: "",
            rating: 0,
        });
        setPostValidated(false);
        setModalOpen(false);
    }

    const createPost = () => {
        let data = _.pick(event, ["caption", "drinkName", "lat", "lon", "name", "rating", "timestamp"]);
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
            navigator.geolocation.getCurrentPosition(setPosition);
            return;
        } else {
            return
        }
    }

    const setPosition = (position) => {
        let u1 = Object.assign({}, event);
        u1.lat = position.coords.latitude;
        u1.lon = position.coords.longitude;
        setEvent(u1);
        NotificationManager.success("Location Added");
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
                                    <InputGroup.Prepend >
                                        <Button
                                            variant={"secondary"}
                                            onClick={handleCurLocation}
                                        >
                                            Current Location
                                        </Button>
                                    </InputGroup.Prepend>
                                    <Form.Control required placeholder={"Venue Name"} className={"activity-modal-input"} value={event.name} onChange={(e) => update("name", e)}/>
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