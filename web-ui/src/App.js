import logo from './logo.svg';
import './App.scss';
import { Container } from 'react-bootstrap';
import { Route, Switch, Redirect } from 'react-router';
import Login from './pages/login/login';
import {connect} from "react-redux";
import Home from './pages/home/home';
import Navbar from "./components/navbar/navbar";
import 'react-notifications/lib/notifications.css';


function App({session}) {
  console.log("session", session);
  return (
    <Container fluid className="App">
      {
        session ?
          <>
            <Navbar/>
            <Switch>
              <Route path={"/home"}>
                <Home/>
              </Route>
              <Route exact path={"/"}>
                <Redirect to={"/home"} />
              </Route>
            </Switch>
          </>
        :
          <Login/>
      }
    </Container>
  );
}

export default connect(({session}) => ({session}))(App);
