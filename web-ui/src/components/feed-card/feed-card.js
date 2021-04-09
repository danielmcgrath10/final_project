import { Avatar, Card, CardActions, CardContent, CardHeader, Collapse, IconButton, makeStyles, Typography } from "@material-ui/core";
import { Comment, ExpandMore, LocalBar, ThumbUp } from "@material-ui/icons";
import clsx from "clsx";
import React, { useState } from "react";
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
        post
    } = props;
    const classes = useStyles();
    const [expand, setExpand] = useState(false);

    const handleExpand = () => {
        setExpand(!expand);
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
                <IconButton aria-label={"Like"}>
                    <ThumbUp/>
                </IconButton>
                <IconButton aria-label={"Comment"}>
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
            <Collapse in={expand} timeout={"auto"} unmountOnExit >
            </Collapse>
        </Card>
    );
}