/* eslint-disable no-unused-vars */
import { Box, Button, Input, useToast } from "@chakra-ui/react";
import { getAuth, signInWithPopup, GoogleAuthProvider } from "firebase/auth";
import React, { useContext, useReducer, useState } from "react";
import app from "../../firebaseconfig";
import {
  collection,
  addDoc,
  getFirestore,
  query,
  where,
  getDocs,
} from "firebase/firestore";
import { actions, initialState, reducer } from "../../contexts/EthContext";
import { EthContext } from "../../contexts/EthContext";
import { GoogleAuth, LoginUser, registerUser } from "../Common/GoogleAuth";

const PatientAuth = () => {
  const [state, setstate] = useState(0);
  const GobalState = useContext(EthContext).state;
  const dispatch = useContext(EthContext).dispatch;
  const db = getFirestore(app);
  // console.log("GobalState", GobalState);

  const [UserState, setUserState] = useState(null);

  const toast = useToast();
  const showToast = (statuss, description) => {
    if (!statuss) statuss = "error";
    if (!description) description = "Some Eror occured";
    toast({
      title: statuss,
      description: description,
      status: statuss,
      duration: 5000,
      isClosable: true,
      position: "top-right",
    });
  };
  const loginWithGoogle = async () => {
    try {
      let data = await GoogleAuth("admin", GobalState);
      // console.log("recieved data", data);
      dispatch({
        type: actions.login,
        data: {
          ...data,
        },
      });
      showToast("success", "Loggedin successfully");
    } catch (error) {
      console.log("error MILGYA", error || error.message);
      showToast("error", error || error.message);
    }
  };
  const register = async (role) => {
    if (UserState === null || !UserState.email || !UserState.password) {
      return showToast("error", "Incomplete Credentials");
    }
    try {
      let resposne = await registerUser(UserState, GobalState, dispatch, role);
      console.log("resposne", resposne);
      showToast("success", "Registered successfully");
      dispatch({
        type: actions.changePatientSideBarState,
        data: 0,
      });
    } catch (error) {
      console.log("error MILGYA", error || error.message);
      showToast("error", error || error.message);
    }
  };
  const login = async (role) => {
    if (UserState === null || !UserState.email || !UserState.password) {
      return showToast("error", "Incomplete Credentials");
    }
    try {
      let resposne = await LoginUser(UserState, GobalState, dispatch, role);
      // console.log("resposne ", resposne);
      dispatch({
        type: actions.login,
        data: {
          ...resposne.data,
        },
      });
      showToast("success", "Loggedin successfully");
      dispatch({
        type: actions.changePatientSideBarState,
        data: 0,
      });
    } catch (error) {
      console.log("error MILGYA", error || error.message);
      showToast("error", error || error.message);
    }
  };
  return (
    <Box py="5" px="7">
      PatientAuth
      <Box>
        <Input
          my="2"
          border="2px"
          borderColor={"blackAlpha.800"}
          name="email"
          type="email"
          value={UserState?.email || ""}
          onChange={(e) =>
            setUserState({ ...UserState, [e.target.name]: e.target.value })
          }
        />
        <Input
          my="2"
          border="2px"
          borderColor={"blackAlpha.800"}
          name="password"
          type="password"
          value={UserState?.password || ""}
          onChange={(e) =>
            setUserState({ ...UserState, [e.target.name]: e.target.value })
          }
        />
        <Button
          mx="2"
          my="2"
          border="2px"
          borderColor={"blackAlpha.800"}
          bgColor="transparent"
          onClick={() => register("patient")}
        >
          Register
        </Button>
        <Button
          mx="2"
          my="2"
          border="2px"
          borderColor={"blackAlpha.800"}
          bgColor="transparent"
          onClick={() => login("patient")}
        >
          Login
        </Button>
        <Button
          mx="2"
          my="2"
          border="2px"
          borderColor={"blackAlpha.800"}
          bgColor="transparent"
          onClick={() => loginWithGoogle()}
        >
          Google login
        </Button>
      </Box>
    </Box>
  );
};

export default PatientAuth;
