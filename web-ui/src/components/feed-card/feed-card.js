import { Avatar, Card, CardActions, CardContent, CardHeader, Collapse, IconButton, makeStyles, Typography } from "@material-ui/core";
import { Close, Comment, Create, ExpandMore, LocalBar, ThumbUp } from "@material-ui/icons";
import clsx from "clsx";
import _ from "lodash";
import React, { useState } from "react";
import { Form, Row } from "react-bootstrap";
import { add_comment, delete_comment } from "../../api";
import "./feed-card.scss";

// Got this format from the Material Ui Site
const useStyles = makeStyles((theme) => ({
    expand: {
      transform: 'rotate(0deg)',
      marginLeft: 'auto',
      transition: theme.transitions.create('transform', {
        duration: theme.transitions.duration.shortest,
      }),
    },
    expandOpen: {
      transform: 'rotate(180deg)',
    },
    avatar: {
        backgroundColor: "blue",
    },
    title: {
        fontSize: "15pt",
    },
    subheader: {
        fontSize: "12pt",
    }
}));

export default function FeedCard(props) {
    const {
        post,
        session
    } = props;
    const classes = useStyles();
    const [expand, setExpand] = useState(false);
    const [comVis, setComVis] = useState(false);
    const [comment, setComment] = useState({body: ""});
    const [comVal, setComVal] = useState(false);

    const handleExpand = () => {
        setExpand(!expand);
    }

    const handleComClick = () => setComVis(!comVis);

    const update = (field, e) => {
        let u1 = Object.assign({}, comment);
        u1[field] = e.target.value;
        setComment(u1);
    };

    const resetCom = () => {
        setComVis(false);
        setComment({body: ""});
        setComVal(false);
    }

    const postCom = () => {
        let data = _.pick(comment, ["body"]);
        data["user_id"] = session.user_id;
        data["post_id"] = post.id;
        add_comment(data, session).then(() => {
            resetCom();
        })
    }

    const handleDelCom = (id) => {
        delete_comment(id, session);
    }

    const handleLikeClick = () => {

    }

    const subCom = (e) => {
        const form = e.currentTarget;
        e.stopPropagation();
        e.preventDefault();

        if(form.checkValidity()) {
            postCom();
        }

        setComVal(true);
    }

    return(
        <Card className={"feed-card"}>
            <CardHeader
                avatar ={
                    <div>
                        <Avatar aria-label={"rating"} className={classes.avatar}>
                            {post.rating}{<LocalBar/>}
                        </Avatar>
                        {post.drinkName}
                    </div>
                }
                title={post.name}
                subheader={
                    <div>
                        {post.user.name}
                    </div>
                }
                classes={{
                    title: classes.title,
                    subheader: classes.subheader,
                }}
            />
            <CardContent>
                <Typography variant={"body2"} color={"textSecondary"} component={"p"} >
                    {post.caption}
                </Typography>
            </CardContent>
            <CardActions disableSpacing>
                <IconButton 
                    onClick={handleLikeClick}
                    aria-label={"Like"}
                >
                    {post.likes.length}
                    <ThumbUp
                        // color={_.find(post.likes, [""])}
                    />
                </IconButton>
                <IconButton
                    onClick={handleComClick}
                    aria-label={"Comment"}
                 >
                    {post.comments.length}
                    <Comment/>
                </IconButton>
                <IconButton 
                    aria-label={"Expand"} 
                    className={clsx(classes.expand, {
                        [classes.expandOpen]: expand,
                      })}
                    onClick={handleExpand}
                    aria-expanded={expand}
                >
                    <ExpandMore/>
                </IconButton>
            </CardActions>
            {
                comVis ?
                    <Form noValidate validated={comVal} onSubmit={subCom} className={"comment-compose"}>
                        <Form.Group className={"comment-input"}>
                            <Form.Control
                                required
                                placeholder={"Comment..."}
                                as={"textarea"}
                                rows={3}
                                value={comment.body}
                                onChange={(e) => update("body", e)}
                            />
                        </Form.Group>
                        <IconButton
                            className={"compose-button"}
                            type={"submit"}
                        >
                            <Create/>
                        </IconButton>
                    </Form>
                :
                    null
            }
            <Collapse in={expand} timeout={"auto"} unmountOnExit className={"card-comments"}>
                {
                    _.isEmpty(post.comments) ?
                        null
                    :
                        _.map(post.comments, (comment, index) => (
                            <Card key={index} className={"comment-card"}>
                                <CardContent>
                                    <Row className={"comment-card-row"}>
                                        {comment.user.name}
                                        {post.user.id === session.user_id ||
                                        comment.user_id === session.user_id ? (
                                            <IconButton
                                                onClick={() => handleDelCom(comment.id)}
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
            </Collapse>
        </Card>
    );
}