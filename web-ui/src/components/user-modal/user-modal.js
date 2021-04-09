import { Modal } from 'bootstrap';
import React, { useEffect, useState } from 'react';
import "./user-modal.scss";

export default function UserModal(props) {
    const {
        user_id,
        session
    } = props;
    const [user, setUser] = useState({});

    useEffect(() => {
        
    }, [user_id]);

    return (
        {
            user
        }
    );
}