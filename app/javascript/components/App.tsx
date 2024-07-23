import React from "react";
import GreenTea from "./GreenTea";
import BlackTea from "./BlackTea";
import { Routes, Route } from "react-router-dom";
import Nav from "./Nav";

export default function App() {
  return (
    <>
      <Nav />
      <Routes>
        <Route path="green-tea" element={<GreenTea />} />
        <Route path="black-tea" element={<BlackTea />} />
      </Routes>
    </>
  );
}
