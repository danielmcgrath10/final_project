// Portions Inpsired By the class Notes
import store from "./store";
import _ from "lodash";
import { NotificationManager } from "react-notifications";

const url = "https://final.danny-mcgrath.com/api/v1";

export async function api_get(path, id=null, input=null, user_id=null, token=null) {
    let text;
    if (user_id && token && input){
      text = await fetch(url + path + "?input=" + input + "&user_id=" + user_id + "&token=" +token);
    } else if(user_id && token && id) {
      text = await fetch(url + path + "?id=" + id + "&user_id=" + user_id + "&token=" +token);
    } else {
      text = await fetch(url + path, {});
    }
    return await text.json(); 
}

export const get_location = async (lat, lon) => {
  let key = "AIzaSyAU3ny9FhTNvsgB6A0CttT8RbaLKDdzf8Q";
  let url = `https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lon}&key=${key}&location_type=APPROXIMATE&result_type=neighborhood`;
  let text = await fetch(url);
  return await text.json();
}

async function api_post(path, data) {
let opts = {
    method: "POST",
    headers: {
    "Content-Type": "application/json",
    },
    body: JSON.stringify(data),
};
let text = await fetch(url + path, opts);
return await text.json();
}
  
async function api_patch(id, path, data) {
let opts = {
    method: "PATCH",
    headers: {
    "Content-Type": "application/json",
    },
    body: JSON.stringify(data),
};
let text = await fetch(
    url + path + "/" + id,
    opts
);
return await text.json();
}


async function api_delete(path, id, session) {
  let text = await fetch(url + path + "/" + id, {
    method: "DELETE",
    headers: {
      "Content-Type": "application/json",
      },
    body: JSON.stringify(session),
  });
  return await text;
}

//Taken from the notes
export function api_login(email, password) {
    api_post("/session", { email: email, password: password }).then((data) => {
      if (data.session) {
        let action = {
          type: "session/set",
          data: data.session,
        };
        store.dispatch(action);
      } else if (data.error) {
        NotificationManager.error(data.error);
        let action = {
          type: "error/set",
          data: data.error,
        };
        store.dispatch(action);
      }
    });
  }

export const create_user = async (data) => {
    api_post("/users", {user: data}).then((res) => {
        if (_.has(res, "error")) {
            console.log(res.error);
        } else {
            api_login(data.email, data.password);
        }
    })
}

export const get_user = async (id) => {
  api_get()
}

export const create_post = async (data, session) => {
  api_post("/posts", {post: data, session: session}).then((res) => {
    if(res.error) {
      console.log(res.error);
      NotificationManager.error(res.error);
      let action = {
        type: "error/set",
        data: res.error,
      };
      store.dispatch(action);
    } else {
      NotificationManager.success("Created Post");
    }
  })
}

export const add_like = async (data, session) => {
  api_post("/likes", {like: data, session: session});
}

export const del_like = async (id, session) => {
  api_delete("/likes", id, {session: session});
}

export const add_comment = async (data, session) => {
  api_post("/comments", {comment: data, session: session});
}

export const delete_comment = async (id, session) => {
  api_delete("/comments", id, {session: session});
}

export const get_reviews = async (input, session) => {
  api_get("/reviews", null, input, session.user_id, session.token).then((data) => {
    store.dispatch({
      type: "reviews/set",
      data: data
    })
  })
}

export const create_review = async(data, session) => {
  let res;
  await api_post("/reviews", {review: data, session: session}).then((data) => {
    store.dispatch({
      type: "reviews/add_review",
      data: data
    })
    res = data;
  })
  return res;
}

export const get_review = async (id, session) => {
  api_get("/reviews", id, null, session.user_id, session.token).then((data) => {
    store.dispatch({
      type: "reviews/add_review",
      data: data
    });
  });
}

export const create_like = async(data, session) => {
  api_post("/votes", {vote: data, session: session}).then(() => get_review(data.review_id, session))
}

export const create_revComment = async (data, session) => {
  api_post("/revcomment", {rev_comment: data, session: session}).then(() => {
    get_review(data.review_id, session);
  })
}

export const delete_revComment = async (id, session, revID) => {
  api_delete("/revcomment", id, {session: session}).then(() => get_review(revID, session));
}