import { Avatar, Box, Card, CardContent, CardHeader, CardMedia, IconButton, Typography } from "@material-ui/core";
import { Close, Create, LocalBar } from "@material-ui/icons";
import Rating from "@material-ui/lab/Rating";
import _ from "lodash";
import React, { useEffect, useState } from "react";
import { Form, Row } from "react-bootstrap";
import { connect } from "react-redux";
import { create_like, create_revComment, create_review, delete_revComment } from "../../api";
import "./review-card.scss";

// Portions are inspired by the course notes
function ReviewCard({session, reviews}) {
    let place = reviews.place.candidates[0];
    let review = reviews.review;
    const [revCom, setRevCom] = useState({body: ""});
    const [revComVal, setRevComVal] = useState(false);
    const [revRating, setRevRating] = useState(0);

    useEffect(() => {
        place = reviews.place.candidates[0];
        review = reviews.review;
    }, [reviews, review, place])

    const update = (field, e) => {
        let u1 = Object.assign({}, revCom);
        u1[field] = e.target.value;
        setRevCom(u1);
    };

    const reset = () => {
        setRevCom({body: ""});
        setRevComVal(false);
        setRevRating(0);
    }

    const subRevCom = (e) => {
        const form = e.currentTarget;
        e.preventDefault();
        e.stopPropagation();

        if(form.checkValidity()){
            let data;
            if(!review){
                data = {
                    place_id: place.place_id,
                    rating: 0
                }
                create_review(data, session).then((newData) => {
                    data = {
                        user_id: session.user_id,
                        review_id: newData.data.id,
                        body: revCom.body
                    }
                    create_revComment(data, session).then(() => reset());
                });
            } else {
                data = {
                    user_id: session.user_id,
                    review_id: review.data.id,
                    body: revCom.body 
                }
                create_revComment(data, session).then(() => reset());
            }
        }

        setRevComVal(true);
    }

    const handleDelRevCom = (id) => {
        delete_revComment(id, session, review.data.id);
    }

    const handleRating = (e) => {
        let val = e.target.value
        setRevRating(val);
        let data;
        if(!review){
            data = {
                place_id: place.place_id,
                rating: 0
            }
            create_review(data, session).then((newData) => {
                data = {
                    user_id: session.user_id,
                    review_id: newData.data.id,
                    value: val
                }
                create_like(data, session).then(()=>setRevRating(0));
            });
        } else {
            data = {
                user_id: session.user_id,
                review_id: review.data.id,
                value: val
            }
            create_like(data, session).then(()=>setRevRating(0));
        }
    }

    const handleKeyPress = (e) => {
        if(e.key === "Enter"){
            subRevCom(e);
        }
    }

    return(
        <Card className={"review-card"}>
            <div className={"review-card-left"}>
                <CardContent className={"review-card-content"}>
                    <CardHeader
                        avatar={
                            <Avatar>
                                <img className={"revcom-img"} src={place.icon} />
                            </Avatar>
                        }
                        title={place.name}
                        subheader={place.formatted_address}
                    />
                    <CardMedia 
                        className={"review-card-image"}
                        image={(_.has(place, "photos") && !_.isEmpty(place.photos)) ? `https://maps.googleapis.com/maps/api/place/photo?maxwidth=${place.photos[0].width}&photoreference=${place.photos[0].photo_reference}&key=AIzaSyAU3ny9FhTNvsgB6A0CttT8RbaLKDdzf8Q&maxheight=${place.photos[0].height}`: null}
                        title={place.name}
                    />
                    <Box className={"review-card-description"}>
                        <Typography component={"legend"}>User Rating: </Typography>
                        <Rating 
                            readOnly
                            name={"Rating"}
                            size={"large"}
                            icon={<LocalBar fontSize={"inherit"} />}
                            value={review ? Number(_.sumBy(review.data.votes, "value")/review.data.votes.length) : 0}
                        />
                    </Box>
                    <Typography className={"review-card-description-item"} >Open: {place.opening_hours.open_now ? "Yes" : "No"} </Typography>
                </CardContent>
            </div>
            <div className={"review-card-right"}>
                <div className={"review-card-feed"}>
                    {
                        (!review || _.isEmpty(review.data.comments)) ?
                            null
                        :
                            _.map(review.data.comments, (comment, index) => (
                                <Card key={index} className={"comment-card"}>
                                    <CardContent>
                                        <Row className={"comment-card-row"}>
                                            {comment.user.name}
                                            {comment.user_id === session.user_id ? (
                                                <IconButton
                                                    onClick={() => handleDelRevCom(comment.id)}
                                                >
                                                    <Close/>
                                                </IconButton>
                                            ) : null}
                                        </Row>
                                        <Row>{comment.body}</Row>
                                    </CardContent>
                                </Card>
                            ))
                    }
                </div>
                <Box>
                    <Typography component={"legend"}>Leave a Rating</Typography>
                    <Rating 
                        name={"Rating"}
                        size={"large"}
                        icon={<LocalBar fontSize={"inherit"} />}
                        value={Number(revRating)}
                        onChange={handleRating}
                    />
                </Box>
                <Form noValidate validated={revComVal} onSubmit={subRevCom} className={"review-compose"}>
                    <Form.Group className={"comment-input"}>
                        <Form.Control
                            required
                            placeholder={"Comment..."}
                            as={"textarea"}
                            rows={3}
                            value={revCom.body}
                            onChange={(e) => update("body", e)}
                            onKeyPress={handleKeyPress}
                        />
                    </Form.Group>
                    <IconButton
                        className={"compose-button"}
                        type={"submit"}
                    >
                        <Create/>
                    </IconButton>
                </Form>
            </div>
        </Card>
    );
}

export default connect(({session, reviews}) => ({session, reviews}))(ReviewCard);