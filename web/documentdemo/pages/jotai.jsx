import React from "react";
import Container from "@material-ui/core/Container";
import Typography from "@material-ui/core/Typography";
import Box from "@material-ui/core/Box";
import { Molecule } from "../src/Molecule";
export default function store() {
  return (
    <React.StrictMode>
      <Container maxWidth="sm">
        <Box my={4}>
          <Typography variant="h4" component="h1" gutterBottom>
            Molecule
        </Typography>
        </Box>
        <Molecule />
      </Container>
    </React.StrictMode>
  );
}
