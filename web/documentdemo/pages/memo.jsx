import React from "react";
import  {DocumentMemo} from "../src/DocumentMemo";
import Container from "@material-ui/core/Container";
import Typography from "@material-ui/core/Typography";
import Box from "@material-ui/core/Box";

export default function State() {
  return (
    <Container maxWidth="sm">
      <Box my={4}>
        <Typography variant="h4" component="h1" gutterBottom>
          Memo Demo
        </Typography>
      </Box>
      <DocumentMemo/>
    </Container>
  );
}
