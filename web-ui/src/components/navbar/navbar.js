// This section is influenced by the notes
import React, { useState } from "react";
import "./navbar.scss";
import { Nav, NavDropdown } from "react-bootstrap";
import _ from "lodash";
import store from "../../store";
import { connect } from "react-redux";

import DrinkModal from "../drink-modal/drink-modal";

function Navbar({ session }) {
  const [modalOpen, setModalOpen] = useState(false);

  let pages = ["feed", "search"];
  const logout = (e) => {
    e.preventDefault();
    store.dispatch({ type: "session/clear" });
  };
  const createActivity = () => setModalOpen(true);


  // This is inspired slightly from a Stack Overflow
  // Post to help with the replacing spaces 
  const popNav = () => {
    return pages.map((page, index) => (
      <Nav.Item key={index}>
        <Nav.Link href={`/${page.replace(/\s/g , "-")}`}>{_.upperFirst(page)}</Nav.Link>
      </Nav.Item>
    ));
  };
  return (
    <>
      <Nav id={"nav"}>
        <div id={"nav-left"}>{popNav()}</div>
        {session ? (
          <div id={"nav-right"}>
            <Nav.Item>
              <Nav.Link onClick={() => createActivity()}>New Drink</Nav.Link>
            </Nav.Item>
            <NavDropdown title={session.email} id={"nav-dropdown"}>
              {/* <NavDropdown.Item href={`/users/${session.user_id}`}>Go To Profile</NavDropdown.Item> */}
              <NavDropdown.Item onClick={logout}>Logout</NavDropdown.Item>
            </NavDropdown>
          </div>
        ) : null}
      </Nav>
      <DrinkModal modalOpen={modalOpen} setModalOpen={setModalOpen} session={session} />
    </>
  );
}

export default connect(({ session }) => ({ session }))(Navbar);
