import React from "react";
import Container from "@material-ui/core/Container";
import Typography from "@material-ui/core/Typography";
import Box from "@material-ui/core/Box";
import  {Document} from "../src/Document";
import { DocumentRef } from "../src/DocumentRef";
export default function Index() {
  return (
    <Container maxWidth="sm">
      <Box my={4}>
        <Typography variant="h4" component="h1" gutterBottom>
          Demo
        </Typography>
      </Box>
      <DocumentRef/>
    </Container>
  );
}
