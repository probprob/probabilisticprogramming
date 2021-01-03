import React from "react";
import Container from "@material-ui/core/Container";
import Typography from "@material-ui/core/Typography";
import Box from "@material-ui/core/Box";
import { DocumentStore } from "../src/DocumentStore";
export default function store() {
  return (
    <Container maxWidth="sm">
      <Box my={4}>
        <Typography variant="h4" component="h1" gutterBottom>
          Store
        </Typography>
      </Box>
      <DocumentStore />
    </Container>
  );
}
