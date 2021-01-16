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
        <Link href="/onchange">State - Controlled Input</Link>
      </Box>
      <Box my={4}>
        <Link href="/state">State - Uncontrolled Input (onBlur)</Link>
      </Box>
      <Box my={4}>
        <Link href="/memo">Memo (useCallback)</Link>
      </Box>
      <Box my={4}>
        <Link href="/store">Store (useRef) - Pagination</Link>
      </Box>
      <Box my={4}>
        <Link href="/jotai">Jotai - Reactive State</Link>
      </Box>
      <Box my={4}>
        <Link href="/jotaiAtomReactComponent">Jotai - Reactive React Component</Link>
      </Box>
    </Container>
  );
}
