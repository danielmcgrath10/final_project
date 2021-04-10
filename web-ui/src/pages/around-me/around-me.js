import { Container, IconButton, Input, Typography } from "@material-ui/core";
import _ from "lodash";
import React, { useState } from "react";
import { Button, Col, Form, FormControl, InputGroup, Row, Spinner } from "react-bootstrap";
import { connect } from "react-redux";
import "./around-me.scss";
import {zipcodes} from "zipcodes";
import { Search } from "@material-ui/icons";
import { get_reviews } from "../../api";
import ReviewCard from "../../components/review-card/review-card";

function AroundMe({session, reviews}) {
    const [loading, setLoading] = useState(false);
    const [input, setInput] = useState("");
    const [aroundVal, setAroundVal] = useState(false);

    const reset = () => {
        setAroundVal(false);
        setInput("");
    }

    const getReviews = () => {
        get_reviews(input, session).then(() => reset());
    }

    const handleSubmit = (e) => {
        const form = e.currentTarget;
        e.preventDefault();
        e.stopPropagation();

        if(form.checkValidity){
            getReviews();
        }
        setAroundVal(true);
    }

    return(
        <Container id={"around-me"}>
            <Row>
                <Col>
                    <Form noValidate validated={aroundVal} onSubmit={handleSubmit}>
                        <InputGroup className={"mb-3"}>
                            <InputGroup.Prepend>
                                <Button 
                                    style={{height: "38px"}}
                                    type={"submit"}
                                >
                                    <Search/>
                                </Button>
                            </InputGroup.Prepend>
                            <FormControl 
                                required
                                placeholder={"Enter Name or Address"}
                                aria-label={"Search Input"}
                                value={input}
                                onChange={(e) => setInput(e.target.value)}
                            />
                        </InputGroup>
                    </Form>
                </Col>
                <Col>
                </Col>
            </Row>
            <Row>
                <Col>
                    {
                        _.isEmpty(reviews) ?
                            loading ?
                                <Spinner />
                            :
                                <Typography>
                                    No Results to Show. Try Another Query
                                </Typography>
                        :
                            <ReviewCard />
                    }
                </Col>
            </Row>
        </Container>
    )
}

export default connect(({session, reviews}) => ({session, reviews}))(AroundMe);