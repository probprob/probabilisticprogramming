import React from "react";
import Container from "@material-ui/core/Container";
import Typography from "@material-ui/core/Typography";
import Box from "@material-ui/core/Box";
import { DocumentPagination } from "../src/DocumentPagination";
import Link from "next/link";

export default function Index() {
  return (
    <Container maxWidth="sm">
      <Box my={4}>
        <Typography variant="h6" component="h1" gutterBottom>
          Demo 
        </Typography>
      </Box>
      <DocumentPagination />
    </Container>
  );
}
