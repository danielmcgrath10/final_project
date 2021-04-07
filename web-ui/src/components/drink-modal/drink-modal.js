import React, { useState } from "react";
import "./drink-modal.scss";
import { Box, FormGroup, TextField, Typography } from "@material-ui/core";
import Rating from "@material-ui/lab/Rating";
import { Modal, Form, InputGroup, Button } from "react-bootstrap";
import { LocalBar, LocalDrink } from "@material-ui/icons";

export default function DrinkModal(props){
    const {
        modalOpen,
        setModalOpen
    } = props;
    const [event, setEvent] = useState({location: "", drink: "", rating: "", review: ""});

    const onHide = () => {
        setModalOpen(false);
    }

    const update = (field, e) => {
        let u1 = Object.assign({}, event);
        u1[field] = e;
    }

    return(
        <Modal show={modalOpen} onHide={onHide} centered>
            <Modal.Header closeButton>
                <Modal.Title>New Drink Excursion</Modal.Title>
            </Modal.Header>
            <Modal.Body>
                <Form>
                    <Form.Group>
                        <InputGroup >
                            <InputGroup.Prepend >
                                <Button
                                    variant={"secondary"}
                                >
                                    Current Location
                                </Button>
                            </InputGroup.Prepend>
                            <Form.Control placeholder={"Venue Name"} className={"activity-modal-input"}/>
                        </InputGroup>
                    </Form.Group>
                    <Form.Group id={"text-input"} >
                        <TextField id={"outlined-basic"} label={"Drink"} variant={"outlined"} />
                    </Form.Group>
                    <Form.Group>
                        <Box>
                            <Typography component={"legend"}>Rating</Typography>
                            <Rating 
                                size={"large"}
                                icon={<LocalBar fontSize={"inherit"} />}
                                onChange={(e) => update("rating", )}
                            />
                        </Box>
                    </Form.Group>
                    <Form.Group>
                        <Form.Control as={"textarea"} rows={3} placeholder={"Leave a Review"}/>
                    </Form.Group>
                </Form>
            </Modal.Body>
        </Modal>
    )
}