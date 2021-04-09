import store from "./store";
import _ from "lodash";
import { NotificationManager } from "react-notifications";

const url = "http://localhost:4000/api/v1";

export async function api_get(path) {
    let text = await fetch(url + path, {});
    let resp = await text.json();
    return resp.data; 
}

async function api_post(path, data) {
let opts = {
    method: "POST",
    headers: {
    "Content-Type": "application/json",
    },
    body: JSON.stringify(data),
};
console.log(opts);
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
console.log(opts);
let text = await fetch(
    url + path + "/" + id,
    opts
);
return await text.json();
}

//Taken from the notes
export function api_login(email, password) {
    api_post("/session", { email: email, password: password }).then((data) => {
      console.log("login resp", data);
      if (data.session) {
        let action = {
          type: "session/set",
          data: data.session,
        };
        store.dispatch(action);
      } else if (data.error) {
        console.log(data.error);
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